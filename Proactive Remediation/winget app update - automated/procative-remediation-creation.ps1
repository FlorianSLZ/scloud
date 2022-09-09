#############################################################################################################
#
#   Tool:       Intune Win32 Deployer - Module/Function
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

    [Parameter(Mandatory = $true)]
    [String] $Publisher = "scloud",

    [Parameter(Mandatory = $true)]
    [String] $PAR_name = "scloud",

    [Parameter(Mandatory = $true)]
    [String] $PAR_description = "Automatically createt via PowerShell",

    [Parameter(Mandatory = $true)]
    [String] $PAR_RunAs = "system",

    [Parameter(Mandatory = $true)]
    [String] $PAR_Scheduler = "Daily",

    [Parameter(Mandatory = $true)]
    [Int] $PAR_Frequency = "1",

    [Parameter(Mandatory = $true)]
    [String] $PAR_StartTime = "10:00",

    [Parameter(Mandatory = $true)]
    [Bool] $PAR_RunAs32 = $true,

    [Parameter(Mandatory = $true)]
    [String] $PAR_AADGroup,

    [Parameter(Mandatory = $true)]
    [String] $PAR_script_detection,

    [Parameter(Mandatory = $true)]
    [String] $PAR_script_remediation

    
)



###############################################################################################################
#                                              CREATE IT                                                      #
###############################################################################################################

$params = @{
         DisplayName = $PAR_name
         Description = $PAR_description
         Publisher = $Publisher
         PAR_RunAs32Bit = $PAR_RunAs32
         RunAsAccount = $PAR_RunAs
         EnforceSignatureCheck = $false
         DetectionScriptContent = [System.Text.Encoding]::ASCII.GetBytes($PAR_script_detection)
         RemediationScriptContent = [System.Text.Encoding]::ASCII.GetBytes($PAR_script_remediation)
         RoleScopeTagIds = @(
                 "0"
         )
}




Write-Host "Connecting to Graph"
Connect-MSGraph



#   Create It
Write-Host "Creating Proactive Remediation: $PAR_name"
$graphApiVersion = "beta"
$Resource = "deviceManagement/deviceHealthScripts"
$uri = "https://graph.microsoft.com/$graphApiVersion/$Resource"

try {
    $proactive = Invoke-MSGraphRequest -Url $uri -HttpMethod Post -Content $params
}
catch {
    Write-Error $_.Exception 
    
}

Write-Host "Proactive Remediation Created"

##Assign It
Write-Host "Assigning Proactive Remediation"
##Connect to Azure AD to find Group ID
Write-Host "Connecting to AzureAD to Query Group"
Connect-AzureAD

##Get Group ID
$AADGroupID = (get-azureadgroup | where-object DisplayName -eq $PAR_AADGroup).ObjectID
Write-Host "Group ID discovered: $AADGroupID"
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

Write-Host "Complete"
