<#
Version: 1.0
Author: Florian Salzmann (scloud.work)

Description: Sets Smart Card Removal Policy service (SCPolicySvc) to Automatic and starts it.

Run this script using the logged-on credentials: No
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

$ServiceName = "SCPolicySvc"

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($service) {
    try {
        Set-Service -Name $ServiceName -StartupType Automatic -ErrorAction Stop
        Write-Host "Successfully set $ServiceName to Automatic startup."

        if ($service.Status -ne 'Running') {
            Start-Service -Name $ServiceName -ErrorAction Stop
            Write-Host "Successfully started $ServiceName."
        } else {
            Write-Host "$ServiceName is already running."
        }

    } catch {
        Write-Error "Error while configuring $ServiceName : $_"
    }
} else {
    Write-Warning "Service $ServiceName not found."
}
