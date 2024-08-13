<#
.DESCRIPTION
    Reads and upload the Autopilot information from a device to Intune. 
.NOTES
    Version:        1.0
    Information:    https://scloud.work/autopilot-registration-app/
    Author:         Florian Salzmann | @FlorianSLZ | https://scloud.work

    Changes: 
        1.0 initial version
  
#>

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted -Force
Write-Host "(i) We will now install the some required components`n" -ForegroundColor Cyan
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Script -Name Get-WindowsAutoPilotInfo -Force | Out-Null
Install-Module -Name WindowsAutopilotIntune -Force | Out-Null

$AutopilotParams = @{
    Online = $true
    TenantId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    AppId = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    AppSecret = "xxxx~xxxxxxxxxxxxxx~xxxxxxxxxxxxxxxxxxxxx"
}

Get-WindowsAutoPilotInfo @AutopilotParams
