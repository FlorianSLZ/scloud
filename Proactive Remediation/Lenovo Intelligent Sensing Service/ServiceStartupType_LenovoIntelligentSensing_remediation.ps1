<#
.DESCRIPTION
    Stops & Sets the "Lenovo Intelligent Sensing Service" to Disabled.

    Run this script using the logged-on credentials: No
    Enforce script signature check: No
    Run script in 64-bit PowerShell: Yes

.NOTES
    Version: 1.0
    Author: Florian Salzmann 

#>

$ServiceName = "SmartSense" # Lenovo Intelligent Sensing Service

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($service) {
    try {
        Set-Service -Name $ServiceName -StartupType Disabled -ErrorAction Stop
        Write-Host "Successfully set $ServiceName to Disabled startup."

        if ($service.Status -eq 'Running') {
            Stop-Service -Name $ServiceName -ErrorAction Stop
            Write-Host "Successfully STOPPED $ServiceName."
        } else {
            Write-Host "$ServiceName is already off."
        }

    } catch {
        Write-Error "Error while configuring $ServiceName : $_"
    }
} else {
    Write-Warning "Service $ServiceName not found."
}
