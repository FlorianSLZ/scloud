<#
.DESCRIPTION
    Checks if the "Lenovo Intelligent Sensing Service" service is running or not set to Disabled.

    Run this script using the logged-on credentials: No
    Enforce script signature check: No
    Run script in 64-bit PowerShell: Yes

.NOTES
    Version: 1.0
    Author: Florian Salzmann 

#>

$ServiceName = "SmartSense" # Lenovo Intelligent Sensing Service

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if (-not $service) {
    Write-Host "Service $ServiceName not found. Nothing to do."
    exit 0
}

if ($service.StartType -ne "Disabled" -or $service.Status -eq "Running") {
    Write-Host "$ServiceName is not set to Disabled or running."
    exit 1
} else {
    Write-Host "$ServiceName is not running and set to Disabled."
    exit 0
}
