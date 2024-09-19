<#
.SYNOPSIS
    Script to detect failed Win32 app installations managed by Microsoft Intune

.DESCRIPTION
    This script identifies failed Intune-managed Win32 application installations on a device 
    and triggers remediation with exit code 1.

.NOTES
    Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
    Version: 1.1

    Changelog:
    - 2022-07-25: 1.0 Initial version by Rudo Oms
    - 2024-09-18: 1.1 Code cleanup and formatting improvement
#>

# Start Logging
Start-Transcript 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\WIN-PR-D-RetryFailedApps_detection.log'


#### FUNCTIONS ####

<#
.SYNOPSIS
    Retrieves the failed Win32 app states from the Intune registry.

.DESCRIPTION
    This function searches the Intune Win32 apps registry key for subkeys containing an EnforcementStateMessage property.
    It extracts the error codes from these properties and identifies failed installations.

.OUTPUTS
    PSCustomObject representing the failed app states.
#>



#### BEGIN FUNCTIONS ####

<#
    .SYNOPSIS
    Retrieves the failed Win32 app states from the Intune registry.
    
    .DESCRIPTION
    This function searches the Intune Win32 apps registry key for subkeys containing an EnforcementStateMessage property.
    It extracts the error codes from these properties and identifies failed installations.

    .OUTPUTS
    PSCustomObject representing the failed app states.
#>
function Get-FailedWin32AppStates {
    $win32AppsKeyPath = 'HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps'
    $appSubKeys = Get-ChildItem -Path $win32AppsKeyPath -Recurse

    $failedStates = @()
    foreach ($subKey in $appSubKeys) {
        $enforcementStateMessage = Get-ItemProperty -Path $subKey.PSPath -Name EnforcementStateMessage -ErrorAction SilentlyContinue
        if ($enforcementStateMessage) {
            if ($enforcementStateMessage.EnforcementStateMessage -match '"ErrorCode":(-?\d+|null)') {
                $errorCode = $matches[1]
                if ($errorCode -ne "null") {
                    $errorCode = [int]$errorCode
                    if (($errorCode -ne 0) -and ($errorCode -ne 3010) -and ($errorCode -ne $null)) {
                        $failedStates += [PSCustomObject]@{
                            SubKeyPath = $subKey.PSPath
                            ErrorCode  = $errorCode
                        }
                    }
                }
            }
        }
    }

    return $failedStates
}

#### SCRIPT ENTRY POINT ####

# Get the failed Win32 app states
$failedStates = Get-FailedWin32AppStates

# Output the result and exit accordingly
if ($failedStates) {
    Write-Host "Failed applications detected:"
    foreach ($failedApp in $failedStates) {
        Write-Host "App Registry Path: $($failedApp.SubKeyPath) `n Error Code: $($failedApp.ErrorCode)" -ForegroundColor Red
    }
    Stop-Transcript
    exit 1
} else {
    Write-Host "No failed applications detected." -ForegroundColor Green
    Stop-Transcript
    exit 0
}
