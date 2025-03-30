<#
Version: 1.0
Author: Florian Salzmann (scloud.work)

Description: Detects if the Smart Card Removal Policy service is not running or not set to Automatic.

Run this script using the logged-on credentials: No
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

$ServiceName = "SCPolicySvc"

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if (-not $service) {
    Write-Host "Service $ServiceName not found."
    exit 1
}

if ($service.StartType -ne "Automatic" -or $service.Status -ne "Running") {
    Write-Host "$ServiceName is not set to Automatic or not running."
    exit 1
} else {
    Write-Host "$ServiceName is running and set to Automatic."
    exit 0
}
