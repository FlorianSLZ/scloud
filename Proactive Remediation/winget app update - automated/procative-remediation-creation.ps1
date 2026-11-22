#############################################################################################################
#
#   Tool:       PAR winget app upgrade automated
#   Author:     Florian Salzmann
#   Website:    http://www.scloud.work
#   Twitter:    https://twitter.com/FlorianSLZ
#   LinkedIn:   https://www.linkedin.com/in/fsalzmann/
#
#############################################################################################################

<#   Example: procative-remediation-creation.ps1 -Publisher $xx `
-PAR_name $xx -PAR_RunAs "system" -PAR_Scheduler "Daily" -PAR_Frequency 1 -PAR_StartTime "10:00" `
-PAR_RunAs32 $true -PAR_AADGroup "APP-WIN-xxx" -PAR_script_detection $path -PAR_script_remediation $path
#>

#    Variables

[CmdletBinding()]
Param (

    [Parameter(Mandatory = $false)]
    [String] $Publisher = "scloud",

    [Parameter(Mandatory = $true)]
    [String] $PAR_name,

    [Parameter(Mandatory = $true)]
    [String] $winget_id,

    [Parameter(Mandatory = $false)]
    [String] $PAR_description = "Automatically createt via PowerShell",

    [Parameter(Mandatory = $false)]
    [String] $PAR_RunAs = "system",

    [Parameter(Mandatory = $false)]
    [String] $PAR_Scheduler = "Daily",

    [Parameter(Mandatory = $false)]
    [Int] $PAR_Frequency = "1",

    [Parameter(Mandatory = $false)]
    [String] $PAR_StartTime = "01:00",

    [Parameter(Mandatory = $false)]
    [Bool] $PAR_RunAs32 = $false,

    [Parameter(Mandatory = $true)]
    [String] $PAR_AADGroup,

    [Parameter(Mandatory = $false)]
    [String] $PAR_detection_path = "$PSScriptRoot\$PAR_name\detection-winget-upgrade.ps1",

    [Parameter(Mandatory = $false)]
    [String] $PAR_remediation_path = "$PSScriptRoot\$PAR_name\remediation-winget-upgrade.ps1"

    
)

##############################################################################################################
#   Check / Install required Modules
##############################################################################################################

$Modules_needed = "Microsoft.Graph", "AzureAD"
try{  
    foreach($Module in $Modules_needed){
        if (!$(Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue)){
        Write-Host "Installing Module: $Module"
        Install-Module $Module -Scope CurrentUser -Force
        }
    }
}catch{$_}

##############################################################################################################
#   Create Detection and Remediation Script
##############################################################################################################
$script_detection = @'
$app_2upgrade = "WINGETPROGRAMID"

$Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe")

if ($(&$winget upgrade --accept-source-agreements) -like "* $app_2upgrade *") {
	Write-Host "Upgrade available for: $app_2upgrade"
	exit 1 # upgrade available, remediation needed
}
else {
		Write-Host "No Upgrade available"
		exit 0 # no upgared, no action needed
}
'@

$script_remediation = @'
$app_2upgrade = "WINGETPROGRAMID"

try{
    $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe")

    # upgrade command
    &$winget upgrade --exact $app_2upgrade --silent --force --accept-package-agreements --accept-source-agreements
    exit 0

}catch{
    Write-Error "Error while installing upgarde for: $app_2upgrade"
    exit 1
}

'@

# Create and save
$PAR_detection = $script_detection.replace("WINGETPROGRAMID","$winget_id") 
$PAR_detection | Out-File (New-Item $PAR_detection_path -Type File -Force) -Encoding utf8
$PAR_remediation = $script_remediation.replace("WINGETPROGRAMID","$winget_id") 
$PAR_remediation | Out-File (New-Item $PAR_remediation_path -Type File -Force) -Encoding utf8



##############################################################################################################
#   Create the Proactive remediation script package
##############################################################################################################
$params = @{
         DisplayName = $PAR_name
         Description = $PAR_description
         Publisher = $Publisher
         PAR_RunAs32Bit = $PAR_RunAs32
         RunAsAccount = $PAR_RunAs
         EnforceSignatureCheck = $false
         DetectionScriptContent = [System.Text.Encoding]::ASCII.GetBytes($PAR_detection)
         RemediationScriptContent = [System.Text.Encoding]::ASCII.GetBytes($PAR_remediation)
         RoleScopeTagIds = @(
                 "0"
         )
}

Write-Host "Connecting to Graph" -ForegroundColor Cyan
Connect-MSGraph

Write-Host "Creating Proactive Remediation: $PAR_name" -ForegroundColor Cyan
$graphApiVersion = "beta"
$Resource = "deviceManagement/deviceHealthScripts"
$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource"

try {
    $proactive = Invoke-MSGraphRequest -Url $uri -HttpMethod Post -Content $params
    Write-Host "Proactive Remediation Created" -ForegroundColor Green
}
catch {
    Write-Error $_.Exception
}

Write-Host "Connecting to AzureAD to query Group to assign" -ForegroundColor Cyan
Connect-AzureAD

#   Get Group ID
$AADGroupID = (Get-AzureADGroup -All $true | where-object DisplayName -eq $PAR_AADGroup).ObjectID
    if($AADGroupID){
    Write-Host "Group ID discovered: $AADGroupID" -ForegroundColor Green
    ##Set the JSON
    if ($PAR_Scheduler -eq "Hourly") {
        Write-Host "Assigning Hourly Schedule running every $PAR_Frequency hours"
    $params = @{
        DeviceHealthScriptAssignments = @(
            @{
                Target = @{
                    "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                    GroupId = $AADGroupID
                }
                RunRemediationScript = $true
                RunSchedule = @{
                    "@odata.type" = "#microsoft.graph.deviceHealthScriptHourlySchedule"
                    Interval = $PAR_Frequency
                }
            }
        )
    }
    }
    else {
        Write-Host "Assigning Daily Schedule running at $PAR_StartTime each $PAR_Frequency days"
        $params = @{
            DeviceHealthScriptAssignments = @(
                @{
                    Target = @{
                        "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                        GroupId = $AADGroupID
                    }
                    RunRemediationScript = $true
                    RunSchedule = @{
                        "@odata.type" = "#microsoft.graph.deviceHealthScriptDailySchedule"
                        Interval = $PAR_Frequency
                        Time = $PAR_StartTime
                        UseUtc = $false
                    }
                }
            )
        }
        }

    $remediationID = $proactive.ID


    $graphApiVersion = "beta"
    $Resource = "deviceManagement/deviceHealthScripts"
    $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource/$remediationID/assign"

    try {
        $proactive = Invoke-MSGraphRequest -Url $uri -HttpMethod Post -Content $params
    }
    catch {
        Write-Error $_.Exception 
        
    }
    Write-Host "Remediation Assigned"

    Write-Host "Complete" -ForegroundColor Green
}else{
    Write-Host "Group $PAR_AADGroup not found, PAR created but not assigned" -ForegroundColor Yellow
}
