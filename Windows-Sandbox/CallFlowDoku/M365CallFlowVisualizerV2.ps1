<#
    .SYNOPSIS
    Reads the configuration from a Microsoft 365 Phone System auto attendant or call queue and visualizes the call flow using mermaid-js.

    .DESCRIPTION
    Reads the configuration from a Microsoft 365 Phone System auto attendant or call queue by either specifying the voice app name and type, unique identity of the voice app or presents a selection of available auto attendants or call queues if none of the identifiers are supplied.
    The call flow is then written into either a mermaid (*.mmd) or a markdown (*.md) file containing the mermaid syntax.

    Author:             Martin Heusser
    Version:            2.1.1
    Revision:
        20.10.2021:     Creation
        21.10.2021:     Add comments and streamline code, add longer arrow links for default call flow desicion node
        21.10.2021:     Add support for top level call queues (besides auto attendants)
        21.10.2021:     Move call queue specific operations into a function
        24.10.2021:     Fixed a bug where Disconnect Call was not reflected in mermaid correctly when CQ timeout action was disconnect call
        30.10.2021:     V2: most of the script logic was moved into functions. Added parameters for specifig resource account (specified by phone number), added support for nested queues, added support to display only 1 queue if timeout and overflow go to the same queue.
        01.11.2021:     Add support to display call queues for an after hours call flow of an auto attendant
        01.11.2021:     Fix issue where additional entry point numbers were not shown on after hours call flow call queues
        02.11.2021:     Add support for nested Auto Attendants
        03.01.2022:     V2.1 more or less a complete rewrite of the script logic to make it really dynamic and support indefinite chaning/nesting of voice apps
                        Add support to disable rendering of nested voice apps
                        Add support for voice app name and type parameters
                        Fixed a bug where some phone numbers which contained extensions including a ";" were not rendered in mermaid. (replace ";" with ",")
                        Fixed a bug where nested voice apps of an auto attendant were rendered even though business hours were set to default.
                        Added support for custom file paths, option to disable saving the file
        04.01.2022      Prettify format of business hours (remove seconds from string)
        05.01.2022      Add H1 Title to Markdown document, add support for mermaid themes default, dark, neutral and forest, change default DocType to Markdown
        05.01.2022      Add new parameters and support for displaying call queue agents opt in status and phone number
        05.01.2022      Fix clipboard content when markdown is selected, add support to display phone numbers assigned to voice apps in grid view selection
        05.01.2022      Change Markdown title from H1 to H2. Fix bug in phone number listing on voice app selection

    .PARAMETER Name
    -Identity
        Specifies the identity of the first / top-level voice app
        Required:           false
        Type:               string
        Accepted values:    unique identifier of an auto attendant or call queue (not resource account) run Get-CsAutoAttendant or Get-CsCallQueue in order to retrieve an identity.
        Default value:      none

    -SetClipBoard
        Specifies if the mermaid code should be copied to the clipboard after the script has finished.
        Required:           false
        Type:               boolean
        Default value:      true
    
    -SaveToFile
        Specifies if the mermaid code should be saved into either a mermaid or markdown file.
        Required:           false
        Type:               boolean
        Default value:      true

    -CustomFilePath
        Specifies the file path for the output file. The directory must already exist.
        Required:           false
        Type:               string
        Accepted values:    file paths e.g. "C:\Temp"
        Default value:      ".\" (current folder)

    -DisplayNestedCallFlows
        Specifies whether or not to also display the call flows of nested call queues or auto attendants. If set to false, only the name of nested voice apps will be rendered. Nested call flows won't be expanded.
        Required:           false
        Type:               boolean
        Default value:      true   

    -ShowCqAgentPhoneNumbers
        Specifies whether or not the agent subgraphs of call queues should include a users direct number.
        Required:           false
        Type:               boolean
        Default value:      false   

    -ShowCqAgentOptInStatus
        Specifies whether or not the current opt in status of agents should be displayed.
        Required:           false
        Type:               boolean
        Default value:      false   

    -DocType
        Specifies the document type.
        Required:           false
        Type:               string
        Accepted values:    Markdown, Mermaid
        Default value:      Markdown

    -Theme
        Specifies the mermaid theme in Markdown
        Required:           false
        Type:               string
        Accepted values:    default, dark, neutral, forest
        Default value:      default
    
    -VoiceAppName
        If provided, you won't be provided with a selection of available voice apps. The script will search for a voice app with the specified name. This is the display name of a voice app, not a resource account. If you specify the VoiceAppName, VoiceAppType will become mandatory.
        Required:           false
        Type:               string
        Accepted values:    Voice App Name
        Default value:      none

    -VoiceAppType
        This becomes mandatory if VoiceAppName is specified. Because an auto attendant and a call queue could have the same arbitrary name, it is neccessary to also specify the type of the voice app, if no unique identity is specified.
        Required:           true, if VoiceAppName is specified
        Type:               string
        Accepted values:    Auto Attendant, Call Queue
        Default value:      none

    .INPUTS
        None.

    .OUTPUTS
        Files:
            - *.md
            - *.mmd

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -DocType Mermaid

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -Theme dark

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -Identity "6fb84b40-f045-45e8-8c1a-8fc18188exxx"

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -VoiceAppName "PS Test AA" -VoiceAppType "Auto Attendant"

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -VoiceAppName "PS Test AA" -VoiceAppType "Auto Attendant" -DisplayNestedCallFlows $false

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -VoiceAppName "PS Test CQ" -VoiceAppType "Call Queue"

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -VoiceAppName "PS Test CQ" -VoiceAppType "Call Queue" -ShowCqAgentPhoneNumbers $true -ShowCqAgentOptInStatus $true

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -DocType Markdown -SetClipBoard $false

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -SafeToFile $false

    .EXAMPLE
        .\M365CallFlowVisualizerV2.ps1 -CustomFilePath "C:\Temp"

    .LINK
    https://github.com/mozziemozz/M365CallFlowVisualizer
    
#>

#Requires -Modules MsOnline, MicrosoftTeams

[CmdletBinding(DefaultParametersetName="None")]
param(
    [Parameter(Mandatory=$false)][String]$Identity,
    [Parameter(Mandatory=$false)][Bool]$SetClipBoard = $true,
    [Parameter(Mandatory=$false)][Bool]$SaveToFile = $true,
    [Parameter(Mandatory=$false)][String]$CustomFilePath,
    [Parameter(Mandatory=$false)][Bool]$DisplayNestedCallFlows = $true,
    [Parameter(Mandatory=$false)][Bool]$ShowCqAgentPhoneNumbers = $false,
    [Parameter(Mandatory=$false)][Bool]$ShowCqAgentOptInStatus = $false,
    [Parameter(Mandatory=$false)][ValidateSet("Markdown","Mermaid")][String]$DocType = "Markdown",
    [Parameter(Mandatory=$false)][ValidateSet("default","forest","dark","neutral")][String]$Theme = "default",
    [Parameter(ParameterSetName="VoiceAppProperties",Mandatory=$false)][String]$VoiceAppName,
    [Parameter(ParameterSetName="VoiceAppProperties",Mandatory=$true)][ValidateSet("Auto Attendant","Call Queue")][String]$VoiceAppType
)

Write-Host "Warning: Some versions of the 'MicrosoftTeams' Module can take a very long time to load. Give it a few minutes before cancelling." -ForegroundColor Yellow

if ($SaveToFile -eq $false -and $CustomFilePath) {

    Write-Host "Warning: Custom file path is specified but SaveToFile is set to false. The call flow won't be saved!" -ForegroundColor Yellow

}

$processedVoiceApps = @()

function Connect-M365CFV {
    param (
    )

    try {
        Get-MsolDomain -ErrorAction Stop > $null
    }
    catch {
        Connect-MsolService
    }

    try {
        Get-CsOnlineSipDomain -ErrorAction Stop > $null
    }
    catch {
        Connect-MicrosoftTeams
    }    
    
}

function Set-Mermaid {
    param (
        [Parameter(Mandatory=$true)][String]$DocType
        )

    if ($DocType -eq "Markdown") {

        $MarkdownTheme =@"
%%{init: {'theme': '$($Theme)', "flowchart" : { "curve" : "basis" } } }%%

"@ 

        $mdStart =@"
## CallFlowNamePlaceHolder

``````mermaid
$MarkdownTheme
flowchart TB
"@

        $mdEnd =@"

``````
"@

        $fileExtension = ".md"
    }

    else {
        $mdStart =@"
flowchart TB
"@

        $mdEnd =@"

"@

        $fileExtension = ".mmd"
    }

    $mermaidCode = @()

    $mermaidCode += $mdStart
    
}

function Find-Holidays {
    param (
        [Parameter(Mandatory=$true)][String]$VoiceAppId

    )

    $aa = Get-CsAutoAttendant -Identity $VoiceAppId

    if ($aa.CallHandlingAssociations.Type.Value -contains "Holiday") {
        $aaHasHolidays = $true    
    }

    else {
        $aaHasHolidays = $false
    }
    
}

function Find-AfterHours {
    param (
        [Parameter(Mandatory=$true)][String]$VoiceAppId

    )

    $aa = Get-CsAutoAttendant -Identity $VoiceAppId

    Write-Host "Getting call flow for: $($aa.Name)" -ForegroundColor Magenta
    Write-Host "Voice App Id: $($aa.Identity)" -ForegroundColor Magenta

    # Create ps object which has no business hours, needed to check if it matches an auto attendants after hours schedule
    $aaDefaultScheduleProperties = New-Object -TypeName psobject

    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "ComplementEnabled" -Value $true
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "MondayHours" -Value "00:00:00-1.00:00:00"
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "TuesdayHours" -Value "00:00:00-1.00:00:00"
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "WednesdayHours" -Value "00:00:00-1.00:00:00"
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "ThursdayHours" -Value "00:00:00-1.00:00:00"
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "FridayHours" -Value "00:00:00-1.00:00:00"
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "SaturdayHours" -Value "00:00:00-1.00:00:00"
    $aaDefaultScheduleProperties | Add-Member -MemberType NoteProperty -Name "SundayHours" -Value "00:00:00-1.00:00:00"

    # Convert to string for comparison
    $aaDefaultScheduleProperties = $aaDefaultScheduleProperties | Out-String
    
    # Get the current auto attendants after hours schedule and convert to string
    $aaAfterHoursScheduleProperties = ($aa.Schedules | Where-Object {$_.name -match "after"}).WeeklyRecurrentSchedule | Out-String

    # Check if the auto attendant has business hours by comparing the ps object to the actual config of the current auto attendant
    if ($aaDefaultScheduleProperties -eq $aaAfterHoursScheduleProperties) {
        $aaHasAfterHours = $false
    }

    else {
        $aaHasAfterHours = $true
    }
    
}

function Get-AutoAttendantHolidaysAndAfterHours {
    param (
        [Parameter(Mandatory=$true)][String]$VoiceAppId
    )

    $aaObjectId = $aa.Identity

    $holidaySubgraphName = "Holiday-Table-$($aa.Name.Replace(" ","-"))"

    if ($aaHasHolidays -eq $true) {

        # The counter is here so that each element is unique in Mermaid
        $HolidayCounter = 1

        # Create empty mermaid subgraph for holidays
        $mdSubGraphHolidays =@"
subgraph $holidaySubgraphName
    direction LR
"@

        $aaHolidays = $aa.CallHandlingAssociations | Where-Object {$_.Type -match "Holiday" -and $_.Enabled -eq $true}

        foreach ($HolidayCallHandling in $aaHolidays) {

            $holidayCallFlow = $aa.CallFlows | Where-Object {$_.Id -eq $HolidayCallHandling.CallFlowId}
            $holidaySchedule = $aa.Schedules | Where-Object {$_.Id -eq $HolidayCallHandling.ScheduleId}

            if (!$holidayCallFlow.Greetings) {

                $holidayGreeting = "Greeting <br> None"

            }

            else {

                $holidayGreeting = "Greeting <br> $($holidayCallFlow.Greetings.ActiveType.Value)"

            }

            $holidayAction = $holidayCallFlow.Menu.MenuOptions.Action.Value

            # Check if holiday call handling is disconnect call
            if ($holidayAction -eq "DisconnectCall") {

                $nodeElementHolidayAction = "elementAAHolidayAction$($aaObjectId)-$($HolidayCounter)(($holidayAction))"

            }

            else {

                $holidayActionTargetType = $holidayCallFlow.Menu.MenuOptions.CallTarget.Type.Value

                # Switch through different transfer call to target types
                switch ($holidayActionTargetType) {
                    User { $holidayActionTargetTypeFriendly = "User" 
                    $holidayActionTargetName = (Get-MsolUser -ObjectId $($holidayCallFlow.Menu.MenuOptions.CallTarget.Id)).DisplayName
                }
                    SharedVoicemail { $holidayActionTargetTypeFriendly = "Voicemail"
                    $holidayActionTargetName = (Get-MsolGroup -ObjectId $($holidayCallFlow.Menu.MenuOptions.CallTarget.Id)).DisplayName
                }
                    ExternalPstn { $holidayActionTargetTypeFriendly = "External Number" 
                    $holidayActionTargetName =  ($holidayCallFlow.Menu.MenuOptions.CallTarget.Id).Replace("tel:","")
                }
                    # Check if the application endpoint is an auto attendant or a call queue
                    ApplicationEndpoint {                    
                    $MatchingAA = Get-CsAutoAttendant | Where-Object {$_.ApplicationInstances -eq $holidayCallFlow.Menu.MenuOptions.CallTarget.Id}

                        if ($MatchingAA) {

                            $holidayActionTargetTypeFriendly = "[Auto Attendant"
                            $holidayActionTargetName = "$($MatchingAA.Name)]"

                        }

                        else {

                            $MatchingCQ = Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq $holidayCallFlow.Menu.MenuOptions.CallTarget.Id}

                            $holidayActionTargetTypeFriendly = "[Call Queue"
                            $holidayActionTargetName = "$($MatchingCQ.Name)]"

                        }

                    }
                
                }

                # Create mermaid code for the holiday action node based on the variables created in the switch statemenet
                $nodeElementHolidayAction = "elementAAHolidayAction$($aaObjectId)-$($HolidayCounter)($holidayAction) --> elementAAHolidayActionTargetType$($aaObjectId)-$($HolidayCounter)($holidayActionTargetTypeFriendly <br> $holidayActionTargetName)"

            }

            # Create subgraph per holiday call handling inside the Holidays subgraph
            $nodeElementHolidayDetails =@"

subgraph $($holidayCallFlow.Name)
direction LR
elementAAHoliday$($aaObjectId)-$($HolidayCounter)(Schedule <br> $($holidaySchedule.FixedSchedule.DateTimeRanges.Start) <br> $($holidaySchedule.FixedSchedule.DateTimeRanges.End)) --> elementAAHolidayGreeting$($aaObjectId)-$($HolidayCounter)>$holidayGreeting] --> $nodeElementHolidayAction
    end
"@

            # Increase the counter by 1
            $HolidayCounter ++

            # Add holiday call handling subgraph to holiday subgraph
            $mdSubGraphHolidays += $nodeElementHolidayDetails

        } # End of for-each loop

        # Create end for the holiday subgraph
        $mdSubGraphHolidaysEnd =@"

    end
"@
            
        # Add the end to the holiday subgraph mermaid code
        $mdSubGraphHolidays += $mdSubGraphHolidaysEnd

        # Mermaid node holiday check
        $nodeElementHolidayCheck = "elementHolidayCheck$($aaObjectId){During Holiday?}"
    } # End if aa has holidays

    # Check if auto attendant has after hours and holidays
    if ($aaHasAfterHours) {

        # Get the business hours schedule and convert to csv for comparison with hard coded strings
        $aaBusinessHours = ($aa.Schedules | Where-Object {$_.name -match "after"}).WeeklyRecurrentSchedule | ConvertTo-Csv

        # Convert from csv to read the business hours per day
        $aaBusinessHoursFriendly = $aaBusinessHours | ConvertFrom-Csv

        $aaTimeZone = $aa.TimeZoneId

        # Monday
        # Check if Monday has business hours which are open 24 Hours per day
        if ($aaBusinessHoursFriendly.DisplayMondayHours -eq "00:00:00-1.00:00:00") {
            $mondayHours = "Monday Hours: Open 24 Hours"
        }
        # Check if Monday has business hours set different than 24 Hours open per day
        elseif ($aaBusinessHoursFriendly.DisplayMondayHours) {
            $mondayHours = "Monday Hours: $($aaBusinessHoursFriendly.DisplayMondayHours)"

            if ($mondayHours -match ",") {

                $mondayHoursTimeRanges = $mondayHours.Split(",")

                $mondayHoursFirstTimeRange = "$($mondayHoursTimeRanges[0])"
                $MondayHoursFirstTimeRangeStart = $mondayHoursFirstTimeRange.Split("-")[0].Remove(($mondayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $MondayHoursFirstTimeRangeEnd = $mondayHoursFirstTimeRange.Split("-")[1].Remove(($mondayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $mondayHours = "$MondayHoursFirstTimeRangeStart - $MondayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $mondayHoursTimeRanges | Where-Object {$_ -notcontains $mondayHoursTimeRanges[0]} ) {

                    $MondayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Monday Hours: ","")
                    $MondayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $mondayHours += (", $MondayHoursStart - $MondayHoursEnd")
                }

            }

            else {

                $MondayHoursStart = $MondayHours.Split("-")[0].Remove(($MondayHours.Split("-")[0]).Length -3)
                $MondayHoursEnd = $MondayHours.Split("-")[1].Remove(($MondayHours.Split("-")[1]).Length -3)
                $MondayHours = "$MondayHoursStart - $MondayHoursEnd"    

            }

        }
        # Check if Monday has no business hours at all / is closed 24 Hours per day
        else {
            $mondayHours = "Monday Hours: Closed"
        }

        # Tuesday
        if ($aaBusinessHoursFriendly.DisplayTuesdayHours -eq "00:00:00-1.00:00:00") {
            $TuesdayHours = "Tuesday Hours: Open 24 Hours"
        }
        elseif ($aaBusinessHoursFriendly.DisplayTuesdayHours) {
            $TuesdayHours = "Tuesday Hours: $($aaBusinessHoursFriendly.DisplayTuesdayHours)"

            if ($TuesdayHours -match ",") {

                $TuesdayHoursTimeRanges = $TuesdayHours.Split(",")

                $TuesdayHoursFirstTimeRange = "$($TuesdayHoursTimeRanges[0])"
                $TuesdayHoursFirstTimeRangeStart = $TuesdayHoursFirstTimeRange.Split("-")[0].Remove(($TuesdayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $TuesdayHoursFirstTimeRangeEnd = $TuesdayHoursFirstTimeRange.Split("-")[1].Remove(($TuesdayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $TuesdayHours = "$TuesdayHoursFirstTimeRangeStart - $TuesdayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $TuesdayHoursTimeRanges | Where-Object {$_ -notcontains $TuesdayHoursTimeRanges[0]} ) {

                    $TuesdayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Tuesday Hours: ","")
                    $TuesdayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $TuesdayHours += (", $TuesdayHoursStart - $TuesdayHoursEnd")
                }

            }

            else {

                $TuesdayHoursStart = $TuesdayHours.Split("-")[0].Remove(($TuesdayHours.Split("-")[0]).Length -3)
                $TuesdayHoursEnd = $TuesdayHours.Split("-")[1].Remove(($TuesdayHours.Split("-")[1]).Length -3)
                $TuesdayHours = "$TuesdayHoursStart - $TuesdayHoursEnd"    

            }

        } 
        else {
            $TuesdayHours = "Tuesday Hours: Closed"
        }

        # Wednesday
        if ($aaBusinessHoursFriendly.DisplayWednesdayHours -eq "00:00:00-1.00:00:00") {
            $WednesdayHours = "Wednesday Hours: Open 24 Hours"
        } 
        elseif ($aaBusinessHoursFriendly.DisplayWednesdayHours) {
            $WednesdayHours = "Wednesday Hours: $($aaBusinessHoursFriendly.DisplayWednesdayHours)"

            if ($WednesdayHours -match ",") {

                $WednesdayHoursTimeRanges = $WednesdayHours.Split(",")

                $WednesdayHoursFirstTimeRange = "$($WednesdayHoursTimeRanges[0])"
                $WednesdayHoursFirstTimeRangeStart = $WednesdayHoursFirstTimeRange.Split("-")[0].Remove(($WednesdayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $WednesdayHoursFirstTimeRangeEnd = $WednesdayHoursFirstTimeRange.Split("-")[1].Remove(($WednesdayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $WednesdayHours = "$WednesdayHoursFirstTimeRangeStart - $WednesdayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $WednesdayHoursTimeRanges | Where-Object {$_ -notcontains $WednesdayHoursTimeRanges[0]} ) {

                    $WednesdayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Wednesday Hours: ","")
                    $WednesdayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $WednesdayHours += (", $WednesdayHoursStart - $WednesdayHoursEnd")
                }

            }

            else {

                $WednesdayHoursStart = $WednesdayHours.Split("-")[0].Remove(($WednesdayHours.Split("-")[0]).Length -3)
                $WednesdayHoursEnd = $WednesdayHours.Split("-")[1].Remove(($WednesdayHours.Split("-")[1]).Length -3)
                $WednesdayHours = "$WednesdayHoursStart - $WednesdayHoursEnd"    

            }

        }
        else {
            $WednesdayHours = "Wednesday Hours: Closed"
        }

        # Thursday
        if ($aaBusinessHoursFriendly.DisplayThursdayHours -eq "00:00:00-1.00:00:00") {
            $ThursdayHours = "Thursday Hours: Open 24 Hours"
        } 
        elseif ($aaBusinessHoursFriendly.DisplayThursdayHours) {
            $ThursdayHours = "Thursday Hours: $($aaBusinessHoursFriendly.DisplayThursdayHours)"

            if ($ThursdayHours -match ",") {

                $ThursdayHoursTimeRanges = $ThursdayHours.Split(",")

                $ThursdayHoursFirstTimeRange = "$($ThursdayHoursTimeRanges[0])"
                $ThursdayHoursFirstTimeRangeStart = $ThursdayHoursFirstTimeRange.Split("-")[0].Remove(($ThursdayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $ThursdayHoursFirstTimeRangeEnd = $ThursdayHoursFirstTimeRange.Split("-")[1].Remove(($ThursdayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $ThursdayHours = "$ThursdayHoursFirstTimeRangeStart - $ThursdayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $ThursdayHoursTimeRanges | Where-Object {$_ -notcontains $ThursdayHoursTimeRanges[0]} ) {

                    $ThursdayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Thursday Hours: ","")
                    $ThursdayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $ThursdayHours += (", $ThursdayHoursStart - $ThursdayHoursEnd")
                }

            }

            else {

                $ThursdayHoursStart = $ThursdayHours.Split("-")[0].Remove(($ThursdayHours.Split("-")[0]).Length -3)
                $ThursdayHoursEnd = $ThursdayHours.Split("-")[1].Remove(($ThursdayHours.Split("-")[1]).Length -3)
                $ThursdayHours = "$ThursdayHoursStart - $ThursdayHoursEnd"    

            }

        }
        else {
            $ThursdayHours = "Thursday Hours: Closed"
        }

        # Friday
        if ($aaBusinessHoursFriendly.DisplayFridayHours -eq "00:00:00-1.00:00:00") {
            $FridayHours = "Friday Hours: Open 24 Hours"
        } 
        elseif ($aaBusinessHoursFriendly.DisplayFridayHours) {
            $FridayHours = "Friday Hours: $($aaBusinessHoursFriendly.DisplayFridayHours)"

            if ($FridayHours -match ",") {

                $FridayHoursTimeRanges = $FridayHours.Split(",")

                $FridayHoursFirstTimeRange = "$($FridayHoursTimeRanges[0])"
                $FridayHoursFirstTimeRangeStart = $FridayHoursFirstTimeRange.Split("-")[0].Remove(($FridayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $FridayHoursFirstTimeRangeEnd = $FridayHoursFirstTimeRange.Split("-")[1].Remove(($FridayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $FridayHours = "$FridayHoursFirstTimeRangeStart - $FridayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $FridayHoursTimeRanges | Where-Object {$_ -notcontains $FridayHoursTimeRanges[0]} ) {

                    $FridayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Friday Hours: ","")
                    $FridayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $FridayHours += (", $FridayHoursStart - $FridayHoursEnd")
                }

            }

            else {

                $FridayHoursStart = $FridayHours.Split("-")[0].Remove(($FridayHours.Split("-")[0]).Length -3)
                $FridayHoursEnd = $FridayHours.Split("-")[1].Remove(($FridayHours.Split("-")[1]).Length -3)
                $FridayHours = "$FridayHoursStart - $FridayHoursEnd"    

            }

        }
        else {
            $FridayHours = "Friday Hours: Closed"
        }

        # Saturday
        if ($aaBusinessHoursFriendly.DisplaySaturdayHours -eq "00:00:00-1.00:00:00") {
            $SaturdayHours = "Saturday Hours: Open 24 Hours"
        } 

        elseif ($aaBusinessHoursFriendly.DisplaySaturdayHours) {
            $SaturdayHours = "Saturday Hours: $($aaBusinessHoursFriendly.DisplaySaturdayHours)"

            if ($SaturdayHours -match ",") {

                $SaturdayHoursTimeRanges = $SaturdayHours.Split(",")

                $SaturdayHoursFirstTimeRange = "$($SaturdayHoursTimeRanges[0])"
                $SaturdayHoursFirstTimeRangeStart = $SaturdayHoursFirstTimeRange.Split("-")[0].Remove(($SaturdayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $SaturdayHoursFirstTimeRangeEnd = $SaturdayHoursFirstTimeRange.Split("-")[1].Remove(($SaturdayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $SaturdayHours = "$SaturdayHoursFirstTimeRangeStart - $SaturdayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $SaturdayHoursTimeRanges | Where-Object {$_ -notcontains $SaturdayHoursTimeRanges[0]} ) {

                    $SaturdayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Saturday Hours: ","")
                    $SaturdayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $SaturdayHours += (", $SaturdayHoursStart - $SaturdayHoursEnd")
                }

            }

            else {

                $SaturdayHoursStart = $SaturdayHours.Split("-")[0].Remove(($SaturdayHours.Split("-")[0]).Length -3)
                $SaturdayHoursEnd = $SaturdayHours.Split("-")[1].Remove(($SaturdayHours.Split("-")[1]).Length -3)
                $SaturdayHours = "$SaturdayHoursStart - $SaturdayHoursEnd"    

            }

        }

        else {
            $SaturdayHours = "Saturday Hours: Closed"
        }

        # Sunday
        if ($aaBusinessHoursFriendly.DisplaySundayHours -eq "00:00:00-1.00:00:00") {
            $SundayHours = "Sunday Hours: Open 24 Hours"
        }
        elseif ($aaBusinessHoursFriendly.DisplaySundayHours) {
            $SundayHours = "Sunday Hours: $($aaBusinessHoursFriendly.DisplaySundayHours)"

            if ($SundayHours -match ",") {

                $SundayHoursTimeRanges = $SundayHours.Split(",")

                $SundayHoursFirstTimeRange = "$($SundayHoursTimeRanges[0])"
                $SundayHoursFirstTimeRangeStart = $SundayHoursFirstTimeRange.Split("-")[0].Remove(($SundayHoursFirstTimeRange.Split("-")[0]).Length -3)
                $SundayHoursFirstTimeRangeEnd = $SundayHoursFirstTimeRange.Split("-")[1].Remove(($SundayHoursFirstTimeRange.Split("-")[1]).Length -3)
                $SundayHours = "$SundayHoursFirstTimeRangeStart - $SundayHoursFirstTimeRangeEnd"
    

                foreach ($TimeRange in $SundayHoursTimeRanges | Where-Object {$_ -notcontains $SundayHoursTimeRanges[0]} ) {

                    $SundayHoursStart = ($TimeRange.Split("-")[0].Remove(($TimeRange.Split("-")[0]).Length -3)).Replace("Sunday Hours: ","")
                    $SundayHoursEnd = ($TimeRange.Split("-")[1].Remove(($TimeRange.Split("-")[1]).Length -3))

                    $SundayHours += (", $SundayHoursStart - $SundayHoursEnd")
                }

            }

            else {

                $SundayHoursStart = $SundayHours.Split("-")[0].Remove(($SundayHours.Split("-")[0]).Length -3)
                $SundayHoursEnd = $SundayHours.Split("-")[1].Remove(($SundayHours.Split("-")[1]).Length -3)
                $SundayHours = "$SundayHoursStart - $SundayHoursEnd"    

            }

        }

        else {
            $SundayHours = "Sunday Hours: Closed"
        }

        # Create the mermaid node for business hours check including the actual business hours
        $nodeElementAfterHoursCheck = "elementAfterHoursCheck$($aaObjectId){During Business Hours? <br> Time Zone: $aaTimeZone <br> $mondayHours <br> $tuesdayHours  <br> $wednesdayHours  <br> $thursdayHours <br> $fridayHours <br> $saturdayHours <br> $sundayHours}"

    } # End if aa has after hours

    $nodeElementHolidayLink = "$($aa.Identity)([Auto Attendant <br> $($aa.Name)])"

    if ($aaHasHolidays -eq $true) {

        if ($aaHasAfterHours) {

            $mdHolidayAndAfterHoursCheck =@"
$nodeElementHolidayLink --> $nodeElementHolidayCheck
$nodeElementHolidayCheck -->|Yes| $holidaySubgraphName
$nodeElementHolidayCheck -->|No| $nodeElementAfterHoursCheck
$nodeElementAfterHoursCheck -->|No| $mdAutoAttendantAfterHoursCallFlow
$nodeElementAfterHoursCheck -->|Yes| $mdAutoAttendantDefaultCallFlow

$mdSubGraphHolidays

"@
        }

        else {
            $mdHolidayAndAfterHoursCheck =@"
$nodeElementHolidayLink --> $nodeElementHolidayCheck
$nodeElementHolidayCheck -->|Yes| $holidaySubgraphName
$nodeElementHolidayCheck -->|No| $mdAutoAttendantDefaultCallFlow

$mdSubGraphHolidays

"@
        }

    }

    
    # Check if auto attendant has no Holidays but after hours
    else {
    
        if ($aaHasAfterHours -eq $true) {

            $mdHolidayAndAfterHoursCheck =@"
$nodeElementHolidayLink --> $nodeElementAfterHoursCheckCheck
$nodeElementAfterHoursCheck -->|No| $mdAutoAttendantAfterHoursCallFlow
$nodeElementAfterHoursCheck -->|Yes| $mdAutoAttendantDefaultCallFlow


"@      
        }

        # Check if auto attendant has no after hours and no holidays
        else {

            $mdHolidayAndAfterHoursCheck =@"
$nodeElementHolidayLink --> $mdAutoAttendantDefaultCallFlow

"@
        }

    
    }

    #Check if AA is not already present in mermaid code
    if ($mermaidCode -notcontains $mdHolidayAndAfterHoursCheck) {

        $mermaidCode += $mdHolidayAndAfterHoursCheck

    }


}

function Get-AutoAttendantDefaultCallFlow {
    param (
        [Parameter(Mandatory=$false)][String]$VoiceAppId
    )

    $aaDefaultCallFlowAaObjectId = $aa.Identity

    # Get the current auto attendants default call flow and default call flow action
    $defaultCallFlow = $aa.DefaultCallFlow
    $defaultCallFlowAction = $aa.DefaultCallFlow.Menu.MenuOptions.Action.Value

    # Get the current auto attentans default call flow greeting
    if (!$defaultCallFlow.Greetings.ActiveType.Value){
        $defaultCallFlowGreeting = "Greeting <br> None"
    }

    else {
        $defaultCallFlowGreeting = "Greeting <br> $($defaultCallFlow.Greetings.ActiveType.Value)"
    }

    # Check if the default callflow action is transfer call to target
    if ($defaultCallFlowAction -eq "TransferCallToTarget") {

        # Get transfer target type
        $defaultCallFlowTargetType = $aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Type.Value

        # Switch through transfer target type and set variables accordingly
        switch ($defaultCallFlowTargetType) {
            User { 
                $defaultCallFlowTargetTypeFriendly = "User"
                $defaultCallFlowTargetUser = (Get-MsolUser -ObjectId $($aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Id))
                $defaultCallFlowTargetName = $defaultCallFlowTargetUser.DisplayName
                $defaultCallFlowTargetIdentity = $defaultCallFlowTargetUser.ObjectId
            }
            ExternalPstn { 
                $defaultCallFlowTargetTypeFriendly = "External PSTN"
                $defaultCallFlowTargetName = ($aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Id).Replace("tel:","")
                $defaultCallFlowTargetIdentity = $defaultCallFlowTargetName
            }
            ApplicationEndpoint {

                # Check if application endpoint is auto attendant or call queue
                $MatchingAaDefaultCallFlowAa = Get-CsAutoAttendant | Where-Object {$_.ApplicationInstances -eq $aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Id}

                if ($MatchingAaDefaultCallFlowAa) {

                    $defaultCallFlowTargetTypeFriendly = "[Auto Attendant"
                    $defaultCallFlowTargetName = "$($MatchingAaDefaultCallFlowAa.Name)]"

                }

                else {

                    $MatchingCqAaDefaultCallFlow = Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq $aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Id}

                    $defaultCallFlowTargetTypeFriendly = "[Call Queue"
                    $defaultCallFlowTargetName = "$($MatchingCqAaDefaultCallFlow.Name)]"

                }

            }
            SharedVoicemail {

                $defaultCallFlowTargetTypeFriendly = "Voicemail"
                $defaultCallFlowTargetGroup = (Get-MsolGroup -ObjectId $aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Id)
                $defaultCallFlowTargetName = $defaultCallFlowTargetGroup.DisplayName
                $defaultCallFlowTargetIdentity = $defaultCallFlowTargetGroup.ObjectId

            }
        }

        ### move this part to switch statement!

        # Check if transfer target type is call queue
        if ($defaultCallFlowTargetTypeFriendly -eq "[Call Queue") {

            $MatchingCQIdentity = (Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq $aa.DefaultCallFlow.Menu.MenuOptions.CallTarget.Id}).Identity

            $mdAutoAttendantDefaultCallFlow = "defaultCallFlowGreeting$($aaDefaultCallFlowAaObjectId)>$defaultCallFlowGreeting] --> defaultCallFlow$($aaDefaultCallFlowAaObjectId)($defaultCallFlowAction) --> $($MatchingCQIdentity)($defaultCallFlowTargetTypeFriendly <br> $defaultCallFlowTargetName)"
            
            if ($nestedVoiceApps -notcontains $MatchingCQIdentity) {

                $nestedVoiceApps += $MatchingCQIdentity

            }

        
        } # End if transfer target type is call queue

        elseif ($defaultCallFlowTargetTypeFriendly -eq "[Auto Attendant") {

            $mdAutoAttendantDefaultCallFlow = "defaultCallFlowGreeting$($aaDefaultCallFlowAaObjectId)>$defaultCallFlowGreeting] --> defaultCallFlow$($aaDefaultCallFlowAaObjectId)($defaultCallFlowAction) --> $($MatchingAaDefaultCallFlowAa.Identity)($defaultCallFlowTargetTypeFriendly <br> $defaultCallFlowTargetName)"

            if ($nestedVoiceApps -notcontains $MatchingAaDefaultCallFlowAa.Identity) {

                $nestedVoiceApps += $MatchingAaDefaultCallFlowAa.Identity

            }

        }

        # Check if default callflow action target is trasnfer call to target but something other than call queue
        else {

            $mdAutoAttendantDefaultCallFlow = "defaultCallFlowGreeting$($aaDefaultCallFlowAaObjectId)>$defaultCallFlowGreeting] --> defaultCallFlow$($aaDefaultCallFlowAaObjectId)($defaultCallFlowAction) --> $($defaultCallFlowTargetIdentity)($defaultCallFlowTargetTypeFriendly <br> $defaultCallFlowTargetName)"

        }

    }

    # Check if default callflow action is disconnect call
    elseif ($defaultCallFlowAction -eq "DisconnectCall") {

        $mdAutoAttendantDefaultCallFlow = "defaultCallFlowGreeting$($aaDefaultCallFlowAaObjectId)>$defaultCallFlowGreeting] --> defaultCallFlow$($aaDefaultCallFlowAaObjectId)(($defaultCallFlowAction))"

    }
    
    
}

function Get-AutoAttendantAfterHoursCallFlow {
    param (
        [Parameter(Mandatory=$false)][String]$VoiceAppId
    )

    $aaAfterHoursCallFlowAaObjectId = $aa.Identity

    # Get after hours call flow
    $afterHoursCallFlow = ($aa.CallFlows | Where-Object {$_.Name -Match "after hours"})
    $afterHoursCallFlowAction = ($aa.CallFlows | Where-Object {$_.Name -Match "after hours"}).Menu.MenuOptions.Action.Value

    # Get after hours greeting
    if (!$afterHoursCallFlow.Greetings.ActiveType.Value){
        $afterHoursCallFlowGreeting = "Greeting <br> None"
    }

    else {
        $afterHoursCallFlowGreeting = "Greeting <br> $($afterHoursCallFlow.Greetings.ActiveType.Value)"
    }

    # Check if after hours action is transfer call to target
    if ($afterHoursCallFlowAction -eq "TransferCallToTarget") {

        $afterHoursCallFlowTargetType = $afterHoursCallFlow.Menu.MenuOptions.CallTarget.Type.Value

        # Switch through after hours call flow target type
        switch ($afterHoursCallFlowTargetType) {
            User { 
                $afterHoursCallFlowTargetTypeFriendly = "User"
                $afterHoursCallFlowTargetUser = (Get-MsolUser -ObjectId $($afterHoursCallFlow.Menu.MenuOptions.CallTarget.Id))
                $afterHoursCallFlowTargetName = $afterHoursCallFlowTargetUser.DisplayName
                $afterHoursCallFlowTargetIdentity = $afterHoursCallFlowTargetUser.ObjectId            
            }
            ExternalPstn { 
                $afterHoursCallFlowTargetTypeFriendly = "External PSTN"
                $afterHoursCallFlowTargetName = ($afterHoursCallFlow.Menu.MenuOptions.CallTarget.Id).Replace("tel:","")
                $afterHoursCallFlowTargetIdentity = $afterHoursCallFlowTargetName
            }
            ApplicationEndpoint {

                # Check if application endpoint is an auto attendant or a call queue
                $MatchingAaAfterHoursCallFlowAa = Get-CsAutoAttendant | Where-Object {$_.ApplicationInstances -match $afterHoursCallFlow.Menu.MenuOptions.CallTarget.Id}

                if ($MatchingAaAfterHoursCallFlowAa) {

                    $afterHoursCallFlowTargetTypeFriendly = "[Auto Attendant"
                    $afterHoursCallFlowTargetName = "$($MatchingAaAfterHoursCallFlowAa.Name)]"

                }

                else {

                    $MatchingCqAaAfterHoursCallFlow = Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq $afterHoursCallFlow.Menu.MenuOptions.CallTarget.Id}

                    $afterHoursCallFlowTargetTypeFriendly = "[Call Queue"
                    $afterHoursCallFlowTargetName = "$($MatchingCqAaAfterHoursCallFlow.Name)]"

                }

            }
            SharedVoicemail {

                $afterHoursCallFlowTargetTypeFriendly = "Voicemail"
                $afterHoursCallFlowTargetGroup = (Get-MsolGroup -ObjectId $afterHoursCallFlow.Menu.MenuOptions.CallTarget.Id)
                $afterHoursCallFlowTargetName = $afterHoursCallFlowTargetGroup.DisplayName
                $afterHoursCallFlowTargetIdentity = $afterHoursCallFlowTargetGroup.ObjectId

            }
        }

        # Check if transfer target type is call queue
        if ($afterHoursCallFlowTargetTypeFriendly -eq "[Call Queue") {

            $MatchingCQIdentity = (Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq ($aa.CallFlows.Menu | Where-Object {$_.Name -match "After hours"}).MenuOptions.CallTarget.Id}).Identity

            $mdAutoAttendantAfterHoursCallFlow = "afterHoursCallFlowGreeting$($aaAfterHoursCallFlowAaObjectId)>$AfterHoursCallFlowGreeting] --> AfterHoursCallFlow$($aaAfterHoursCallFlowAaObjectId)($AfterHoursCallFlowAction) --> $($MatchingCQIdentity)($AfterHoursCallFlowTargetTypeFriendly <br> $AfterHoursCallFlowTargetName)"

            if ($nestedVoiceApps -notcontains $MatchingCQIdentity -and $aaHasAfterHours -eq $true) {

                $nestedVoiceApps += $MatchingCQIdentity

            }

            
        } # End if transfer target type is call queue

        elseif ($afterHoursCallFlowTargetTypeFriendly -eq "[Auto Attendant") {

            $mdAutoAttendantAfterHoursCallFlow = "afterHoursCallFlowGreeting$($aaAfterHoursCallFlowAaObjectId)>$AfterHoursCallFlowGreeting] --> AfterHoursCallFlow$($aaAfterHoursCallFlowAaObjectId)($AfterHoursCallFlowAction) --> $($MatchingAaAfterHoursCallFlowAa.Identity)($AfterHoursCallFlowTargetTypeFriendly <br> $AfterHoursCallFlowTargetName)"

            if ($nestedVoiceApps -notcontains $MatchingAaAfterHoursCallFlowAa.Identity -and $aaHasAfterHours -eq $true) {

                $nestedVoiceApps += $MatchingAaAfterHoursCallFlowAa.Identity

            }

        }

        # Check if AfterHours callflow action target is trasnfer call to target but something other than call queue
        else {

            $mdAutoAttendantAfterHoursCallFlow = "afterHoursCallFlowGreeting$($aaAfterHoursCallFlowAaObjectId)>$AfterHoursCallFlowGreeting] --> AfterHoursCallFlow$($aaAfterHoursCallFlowAaObjectId)($AfterHoursCallFlowAction) --> $($afterHoursCallFlowTargetIdentity)($AfterHoursCallFlowTargetTypeFriendly <br> $AfterHoursCallFlowTargetName)"
            
        }

    }

    #Maybe combine all disconnect calls into one node...
    elseif ($afterHoursCallFlowAction -eq "DisconnectCall") {

        $mdAutoAttendantAfterHoursCallFlow = "afterHoursCallFlowGreeting$($aaAfterHoursCallFlowAaObjectId)>$AfterHoursCallFlowGreeting] --> afterHoursCallFlow$($aaAfterHoursCallFlowAaObjectId)(($afterHoursCallFlowAction))"

    }
    

    

}


function Get-CallQueueCallFlow {
    param (
        [Parameter(Mandatory=$true)][String]$MatchingCQIdentity
    )

    $MatchingCQ = Get-CsCallQueue -Identity $MatchingCQIdentity

    $cqCallFlowObjectId = $MatchingCQ.Identity

    Write-Host "Getting call flow for: $($MatchingCQ.Name)" -ForegroundColor Magenta
    Write-Host "Voice App Id: $cqCallFlowObjectId" -ForegroundColor Magenta

    # Store all neccessary call queue properties in variables
    $CqName = $MatchingCQ.Name
    $CqOverFlowThreshold = $MatchingCQ.OverflowThreshold
    $CqOverFlowAction = $MatchingCQ.OverflowAction.Value
    $CqTimeOut = $MatchingCQ.TimeoutThreshold
    $CqTimeoutAction = $MatchingCQ.TimeoutAction.Value
    $CqRoutingMethod = $MatchingCQ.RoutingMethod.Value
    $CqAgents = $MatchingCQ.Agents
    $CqAgentOptOut = $MatchingCQ.AllowOptOut
    $CqConferenceMode = $MatchingCQ.ConferenceMode
    $CqAgentAlertTime = $MatchingCQ.AgentAlertTime
    $CqPresenceBasedRouting = $MatchingCQ.PresenceBasedRouting
    $CqDistributionList = $MatchingCQ.DistributionLists
    $CqDefaultMusicOnHold = $MatchingCQ.UseDefaultMusicOnHold
    $CqWelcomeMusicFileName = $MatchingCQ.WelcomeMusicFileName

    # Check if call queue uses default music on hold
    if ($CqDefaultMusicOnHold -eq $true) {
        $CqMusicOnHold = "Default"
    }

    else {
        $CqMusicOnHold = "Custom"
    }

    # Check if call queue uses a greeting
    if (!$CqWelcomeMusicFileName) {
        $CqGreeting = "None"
    }

    else {
        $CqGreeting = "Audio File"

    }

    # Check if call queue useses users, group or teams channel as distribution list
    if (!$CqDistributionList) {

        $CqAgentListType = "Users"

    }

    else {

        if (!$MatchingCQ.ChannelId) {

            $CqAgentListType = "Group"

        }

        else {

            $CqAgentListType = "Teams Channel"

        }

    }

    # Switch through call queue overflow action target
    switch ($CqOverFlowAction) {
        DisconnectWithBusy {
            $CqOverFlowActionFriendly = "cqOverFlowAction$($cqCallFlowObjectId)((Disconnect Call))"

        }
        Forward {

            if ($MatchingCQ.OverflowActionTarget.Type -eq "User") {

                $MatchingOverFlowUserProperties = (Get-MsolUser -ObjectId $MatchingCQ.OverflowActionTarget.Id)
                $MatchingOverFlowUser = $MatchingOverFlowUserProperties.DisplayName
                $MatchingOverFlowIdentity = $MatchingOverFlowUserProperties.ObjectId

                $CqOverFlowActionFriendly = "cqOverFlowAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($MatchingOverFlowIdentity)(User <br> $MatchingOverFlowUser)"

            }

            elseif ($MatchingCQ.OverflowActionTarget.Type -eq "Phone") {

                $cqOverFlowPhoneNumber = ($MatchingCQ.OverflowActionTarget.Id).Replace("tel:","")

                $CqOverFlowActionFriendly = "cqOverFlowAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($cqOverFlowPhoneNumber)(External Number <br> $cqOverFlowPhoneNumber)"
                
            }

            else {

                $MatchingOverFlowAA = (Get-CsAutoAttendant | Where-Object {$_.ApplicationInstances -eq $MatchingCQ.OverflowActionTarget.Id})

                if ($MatchingOverFlowAA) {

                    $CqOverFlowActionFriendly = "cqOverFlowAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($MatchingOverFlowAA.Identity)([Auto Attendant <br> $($MatchingOverFlowAA.Name)])"

                    if ($nestedVoiceApps -notcontains $MatchingOverFlowAA.Identity) {

                        $nestedVoiceApps += $MatchingOverFlowAA.Identity
        
                    }
        

                }

                else {

                    $MatchingOverFlowCQ = (Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq $MatchingCQ.OverflowActionTarget.Id})

                    $CqOverFlowActionFriendly = "cqOverFlowAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($MatchingOverFlowCQ.Identity)([Call Queue <br> $($MatchingOverFlowCQ.Name)])"

                    if ($nestedVoiceApps -notcontains $MatchingOverFlowCQ.Identity) {

                        $nestedVoiceApps += $MatchingOverFlowCQ.Identity
        
                    }

                }

            }

        }
        SharedVoicemail {
            $MatchingOverFlowVoicemailProperties = (Get-MsolGroup -ObjectId $MatchingCQ.OverflowActionTarget.Id)
            $MatchingOverFlowVoicemail = $MatchingOverFlowVoicemailProperties.DisplayName
            $MatchingOverFlowIdentity = $MatchingOverFlowVoicemailProperties.ObjectId

            if ($MatchingCQ.OverflowSharedVoicemailTextToSpeechPrompt) {

                $CqOverFlowVoicemailGreeting = "TextToSpeech"

            }

            else {

                $CqOverFlowVoicemailGreeting = "AudioFile"

            }

            $CqOverFlowActionFriendly = "cqOverFlowAction$($cqCallFlowObjectId)(TransferCallToTarget) --> cqOverFlowVoicemailGreeting$($cqCallFlowObjectId)>Greeting <br> $CqOverFlowVoicemailGreeting] --> $($MatchingOverFlowIdentity)(Shared Voicemail <br> $MatchingOverFlowVoicemail)"

        }

    }

    # Switch through call queue timeout overflow action
    switch ($CqTimeoutAction) {
        Disconnect {
            $CqTimeoutActionFriendly = "cqTimeoutAction$($cqCallFlowObjectId)((Disconnect Call))"

        }
        Forward {
    
            if ($MatchingCQ.TimeoutActionTarget.Type -eq "User") {

                $MatchingTimeoutUserProperties = (Get-MsolUser -ObjectId $MatchingCQ.TimeoutActionTarget.Id)
                $MatchingTimeoutUser = $MatchingTimeoutUserProperties.DisplayName
                $MatchingTimeoutIdentity = $MatchingTimeoutUserProperties.ObjectId
    
                $CqTimeoutActionFriendly = "cqTimeoutAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($MatchingTimeoutIdentity)(User <br> $MatchingTimeoutUser)"
    
            }
    
            elseif ($MatchingCQ.TimeoutActionTarget.Type -eq "Phone") {
    
                $cqTimeoutPhoneNumber = ($MatchingCQ.TimeoutActionTarget.Id).Replace("tel:","")
    
                $CqTimeoutActionFriendly = "cqTimeoutAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($cqTimeoutPhoneNumber)(External Number <br> $cqTimeoutPhoneNumber)"
                
            }
    
            else {
    
                $MatchingTimeoutAA = (Get-CsAutoAttendant | Where-Object {$_.ApplicationInstances -eq $MatchingCQ.TimeoutActionTarget.Id})
    
                if ($MatchingTimeoutAA) {
    
                    $CqTimeoutActionFriendly = "cqTimeoutAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($MatchingTimeoutAA.Identity)([Auto Attendant <br> $($MatchingTimeoutAA.Name)])"

                    if ($nestedVoiceApps -notcontains $MatchingTimeoutAA.Identity) {

                        $nestedVoiceApps += $MatchingTimeoutAA.Identity
        
                    }

    
                }
    
                else {
    
                    $MatchingTimeoutCQ = (Get-CsCallQueue | Where-Object {$_.ApplicationInstances -eq $MatchingCQ.TimeoutActionTarget.Id})

                    Write-Host "Matching Time Out CQ Name: $($MatchingTimeoutCQ.Name)"

                    $CqTimeoutActionFriendly = "cqTimeoutAction$($cqCallFlowObjectId)(TransferCallToTarget) --> $($MatchingTimeoutCQ.Identity)([Call Queue <br> $($MatchingTimeoutCQ.Name)])"

                    if ($nestedVoiceApps -notcontains $MatchingTimeoutCQ.Identity) {

                        $nestedVoiceApps += $MatchingTimeoutCQ.Identity
        
                    }
    
                }
    
            }
    
        }
        SharedVoicemail {
            $MatchingTimeoutVoicemailProperties = (Get-MsolGroup -ObjectId $MatchingCQ.TimeoutActionTarget.Id)
            $MatchingTimeoutVoicemail = $MatchingTimeoutVoicemailProperties.DisplayName
            $MatchingTimeoutIdentity = $MatchingTimeoutVoicemailProperties.ObjectId
    
            if ($MatchingCQ.TimeoutSharedVoicemailTextToSpeechPrompt) {
    
                $CqTimeoutVoicemailGreeting = "TextToSpeech"
    
            }
    
            else {
    
                $CqTimeoutVoicemailGreeting = "AudioFile"
    
            }
    
            $CqTimeoutActionFriendly = "cqTimeoutAction$($cqCallFlowObjectId)(TransferCallToTarget) --> cqTimeoutVoicemailGreeting$($cqCallFlowObjectId)>Greeting <br> $CqTimeoutVoicemailGreeting] --> $($MatchingTimeoutIdentity)(Shared Voicemail <br> $MatchingTimeoutVoicemail)"
    
        }
    
    }

    # Create empty mermaid element for agent list
    $mdCqAgentsDisplayNames = @"
"@

    # Define agent counter for unique mermaid element names
    $AgentCounter = 1

    # add each agent to the empty agents mermaid element
    foreach ($CqAgent in $CqAgents) {
        $AgentDisplayName = (Get-MsolUser -ObjectId $CqAgent.ObjectId).DisplayName

        if ($ShowCqAgentPhoneNumbers -eq $true) {

            $CqAgentPhoneNumber = ((Get-CsOnlineUser -Identity $($CqAgent.ObjectId)).LineUri).Replace("tel:","")

            $AgentDisplayName = "$AgentDisplayName <br> $CqAgentPhoneNumber"

        }


        if ($ShowCqAgentOptInStatus -eq $true) {

            $AgentDisplayName = "$AgentDisplayName <br> OptIn: $($CqAgent.OptIn)"

        }

        $AgentDisplayNames = "agentListType$($cqCallFlowObjectId) --> agent$($cqCallFlowObjectId)$($AgentCounter)($AgentDisplayName) --> timeOut$($cqCallFlowObjectId)`n"

        $mdCqAgentsDisplayNames += $AgentDisplayNames

        $AgentCounter ++
    }

    $lastCallFlowAction = "$($MatchingCQIdentity)([Call Queue <br> $($CqName)])"

    
    # Create default callflow mermaid code

$mdCallQueueCallFlow =@"
$lastCallFlowAction --> cqGreeting$($cqCallFlowObjectId)>Greeting <br> $CqGreeting] --> overFlow$($cqCallFlowObjectId){More than $CqOverFlowThreshold <br> Active Calls?}
overFlow$($cqCallFlowObjectId) ---> |Yes| $CqOverFlowActionFriendly
overFlow$($cqCallFlowObjectId) ---> |No| routingMethod$($cqCallFlowObjectId)

$nestedCallQueueTopLevelNumbers

subgraph Call Distribution
subgraph CQ Settings
routingMethod$($cqCallFlowObjectId)[(Routing Method: $CqRoutingMethod)] --> agentAlertTime$($cqCallFlowObjectId)
agentAlertTime$($cqCallFlowObjectId)[(Agent Alert Time: $CqAgentAlertTime)] -.- cqMusicOnHold$($cqCallFlowObjectId)
cqMusicOnHold$($cqCallFlowObjectId)[(Music On Hold: $CqMusicOnHold)] -.- conferenceMode$($cqCallFlowObjectId)
conferenceMode$($cqCallFlowObjectId)[(Conference Mode Enabled: $CqConferenceMode)] -.- agentOptOut$($cqCallFlowObjectId)
agentOptOut$($cqCallFlowObjectId)[(Agent Opt Out Allowed: $CqAgentOptOut)] -.- presenceBasedRouting$($cqCallFlowObjectId)
presenceBasedRouting$($cqCallFlowObjectId)[(Presence Based Routing: $CqPresenceBasedRouting)] -.- timeOut$($cqCallFlowObjectId)
timeOut$($cqCallFlowObjectId)[(Timeout: $CqTimeOut Seconds)]
end
subgraph Agents $($MatchingCQ.Name)
agentAlertTime$($cqCallFlowObjectId) --> agentListType$($cqCallFlowObjectId)[(Agent List Type: $CqAgentListType)]
$mdCqAgentsDisplayNames
end
end

timeOut$($cqCallFlowObjectId) --> cqResult$($cqCallFlowObjectId){Call Connected?}
cqResult$($cqCallFlowObjectId) --> |Yes| cqEnd$($cqCallFlowObjectId)((Call Connected))
cqResult$($cqCallFlowObjectId) --> |No| $CqTimeoutActionFriendly

"@

if ($mermaidCode -notcontains $mdCallQueueCallFlow) {

    $mermaidCode += $mdCallQueueCallFlow

}
  
}

. Set-Mermaid -DocType $DocType

. Connect-M365CFV

#This is needed to determine if the Get-CallFlow function is running for the first time or not.
$mdNodePhoneNumbersCounter = 0

#This array stores information about the voice app's forwading targets.
$nestedVoiceApps = @()

function Get-CallFlow {
    param (
        [Parameter(Mandatory=$false)][String]$VoiceAppId,
        [Parameter(Mandatory=$false)][String]$VoiceAppName,
        [Parameter(Mandatory=$false)][String]$voiceAppType
    )
    
    if (!$VoiceAppName -and !$voiceAppType -and !$VoiceAppId) {
        
        $VoiceApps = @()

        $VoiceAppAas = Get-CsAutoAttendant
        $VoiceAppCqs = Get-CsCallQueue

        foreach ($VoiceApp in $VoiceAppAas) {

            $VoiceAppProperties = New-Object -TypeName psobject
            $ResourceAccountPhoneNumbers = ""

            $VoiceAppProperties | Add-Member -MemberType NoteProperty -Name "Name" -Value $VoiceApp.Name
            $VoiceAppProperties | Add-Member -MemberType NoteProperty -Name "Type" -Value "Auto Attendant"

            $ApplicationInstanceAssociationCounter = 0

            foreach ($ResourceAccount in $VoiceApp.ApplicationInstances) {

                $ResourceAccountPhoneNumber = ((Get-CsOnlineApplicationInstance -Identity $ResourceAccount).PhoneNumber)

                if ($ResourceAccountPhoneNumber) {

                    $ResourceAccountPhoneNumber = $ResourceAccountPhoneNumber.Replace("tel:","")

                    $ResourceAccountPhoneNumbers += "$ResourceAccountPhoneNumber, "

                    $ApplicationInstanceAssociationCounter ++
    
                }

            }

            if ($ApplicationInstanceAssociationCounter -lt 2) {

                $ResourceAccountPhoneNumbers = $ResourceAccountPhoneNumbers.Replace(",","")

            }

            else {

                $ResourceAccountPhoneNumbers = $ResourceAccountPhoneNumbers.TrimEnd(", ")

            }

            $VoiceAppProperties | Add-Member -MemberType NoteProperty -Name "PhoneNumbers" -Value $ResourceAccountPhoneNumbers

            $VoiceApps += $VoiceAppProperties

        }

        foreach ($VoiceApp in $VoiceAppCqs) {

            $VoiceAppProperties = New-Object -TypeName psobject
            $ResourceAccountPhoneNumbers = ""

            $VoiceAppProperties | Add-Member -MemberType NoteProperty -Name "Name" -Value $VoiceApp.Name
            $VoiceAppProperties | Add-Member -MemberType NoteProperty -Name "Type" -Value "Call Queue"

            $ApplicationInstanceAssociationCounter = 0

            foreach ($ResourceAccount in $VoiceApp.ApplicationInstances) {

                $ResourceAccountPhoneNumber = ((Get-CsOnlineApplicationInstance -Identity $ResourceAccount).PhoneNumber)

                if ($ResourceAccountPhoneNumber) {

                    $ResourceAccountPhoneNumber = $ResourceAccountPhoneNumber.Replace("tel:","")

                    $ResourceAccountPhoneNumbers += "$ResourceAccountPhoneNumber, "

                    $ApplicationInstanceAssociationCounter ++
    
                }

            }

            if ($ApplicationInstanceAssociationCounter -lt 2) {

                $ResourceAccountPhoneNumbers = $ResourceAccountPhoneNumbers.Replace(",","")

            }

            else {

                $ResourceAccountPhoneNumbers = $ResourceAccountPhoneNumbers.TrimEnd(", ")
                
            }

            $VoiceAppProperties | Add-Member -MemberType NoteProperty -Name "PhoneNumbers" -Value $ResourceAccountPhoneNumbers

            $VoiceApps += $VoiceAppProperties

        }

        $VoiceAppSelection = $VoiceApps | Out-GridView -Title "Choose an Auto Attendant or Call Queue from the list." -PassThru

        if ($VoiceAppSelection.Type -eq "Auto Attendant") {

            $VoiceApp = Get-CsAutoAttendant | Where-Object {$_.Name -eq $VoiceAppSelection.Name}
            $voiceAppType = "Auto Attendant"

        }

        else {

            $VoiceApp = Get-CsCallQueue | Where-Object {$_.Name -eq $VoiceAppSelection.Name}
            $voiceAppType = "Call Queue"

        }


    }

    elseif ($VoiceAppId) {

        try {
            $VoiceApp = Get-CsAutoAttendant -Identity $VoiceAppId
            $voiceAppType = "Auto Attendant"
        }
        catch {
            $VoiceApp = Get-CsCallQueue -Identity $VoiceAppId
            $voiceAppType = "Call Queue"
        }

    }

    else {

        if ($voiceAppType -eq "Auto Attendant") {

            $VoiceApp = Get-CsAutoAttendant | Where-Object {$_.Name -eq $VoiceAppName}

        }

        else {

            $VoiceApp = Get-CsCallQueue | Where-Object {$_.Name -eq $VoiceAppName}

        }

    }

    $mdNodePhoneNumbers = @()

    foreach ($ApplicationInstance in ($VoiceApp.ApplicationInstances)) {

        if ($mdNodePhoneNumbersCounter -eq 0) {

            $mdPhoneNumberLinkType = "-->"
            $VoiceAppFileName = $VoiceApp.Name

        }

        else {

            $mdPhoneNumberLinkType = "-.->"

        }

        $ApplicationInstancePhoneNumber = ((Get-CsOnlineApplicationInstance -Identity $ApplicationInstance).PhoneNumber) -replace ("tel:","")

        if ($ApplicationInstancePhoneNumber) {

            $mdNodeNumber = "start$($ApplicationInstancePhoneNumber)((Incoming Call at <br> $ApplicationInstancePhoneNumber)) $mdPhoneNumberLinkType $($VoiceApp.Identity)([$($voiceAppType) <br> $($VoiceApp.Name)])"

            $mdNodePhoneNumbers += $mdNodeNumber
    
            $mdNodePhoneNumbersCounter ++

        }


    }

    if ($mermaidCode -notcontains $mdNodePhoneNumbers) {

        $mermaidCode += $mdNodePhoneNumbers

    }

    if ($voiceAppType -eq "Auto Attendant") {
        . Find-Holidays -VoiceAppId $VoiceApp.Identity
        . Find-AfterHours -VoiceAppId $VoiceApp.Identity
    
        if ($aaHasHolidays -eq $true -or $aaHasAfterHours -eq $true) {
    
            . Get-AutoAttendantDefaultCallFlow -VoiceAppId $VoiceApp.Identity
    
            . Get-AutoAttendantAfterHoursCallFlow -VoiceAppId $VoiceApp.Identity
    
            . Get-AutoAttendantHolidaysAndAfterHours -VoiceAppId $VoiceApp.Identity
    
        }
    
        else {
    
            . Get-AutoAttendantDefaultCallFlow -VoiceAppId $VoiceApp.Identity

            $nodeElementHolidayLink = "$($aa.Identity)([Auto Attendant <br> $($aa.Name)])"
    
            $mdHolidayAndAfterHoursCheck =@"
            $nodeElementHolidayLink --> $mdAutoAttendantDefaultCallFlow
            
"@

            if ($mermaidCode -notcontains $mdHolidayAndAfterHoursCheck) {

                $mermaidCode += $mdHolidayAndAfterHoursCheck

            }
    
        }
        
    }
    
    elseif ($voiceAppType -eq "Call Queue") {
        . Get-CallQueueCallFlow -MatchingCQIdentity $VoiceApp.Identity
    }

}

# Get First Call Flow
if ($Identity) {

    . Get-CallFlow -VoiceAppId $Identity

}

else {

    . Get-CallFlow -VoiceAppName $VoiceAppName -voiceAppType $VoiceAppType

}

function Get-NestedCallFlow {
    param (
    )

    foreach ($nestedVoiceApp in $nestedVoiceApps) {

        if ($processedVoiceApps -notcontains $nestedVoiceApp) {

            $processedVoiceApps += $nestedVoiceApp

            . Get-CallFlow -VoiceAppId $nestedVoiceApp

        }

    }

    if (Compare-Object -ReferenceObject $nestedVoiceApps -DifferenceObject $processedVoiceApps) {

        . Get-NestedCallFlow

    }

}

if ($DisplayNestedCallFlows -eq $true) {

    . Get-NestedCallFlow

}

else {
    
    if ($nestedVoiceApps) {

        Write-Host "Your call flow contains nested call queues or auto attendants. They won't be expanded because 'DisplayNestedCallFlows' is set to false." -ForegroundColor Yellow
        Write-Host "Nested Voice App Ids:" -ForegroundColor Yellow
        $nestedVoiceApps

    }

}


#Remove invalid characters from mermaid syntax
$mermaidCode = $mermaidCode.Replace(";",",")

#Add H1 Title to Markdown code
$mermaidCode = $mermaidCode.Replace("## CallFlowNamePlaceHolder","# Call Flow $VoiceAppFileName")

if ($SaveToFile -eq $true) {

    if ($CustomFilePath) {

        $FilePath = $CustomFilePath

    }

    else {

        $FilePath = "."

    }

    $mermaidCode += $mdEnd

    Set-Content -Path "$FilePath\$(($VoiceAppFileName).Replace(" ","_"))_CallFlow$fileExtension" -Value $mermaidCode -Encoding UTF8

}

if ($SetClipBoard -eq $true) {
    $mermaidCode -Replace('```mermaid','') `
    -Replace('```','') `
    -Replace("# Call Flow $VoiceAppFileName","") `
    -Replace($MarkdownTheme,"") | Set-Clipboard

    Write-Host "Mermaid code copied to clipboard. Paste it on https://mermaid.live" -ForegroundColor Cyan
}