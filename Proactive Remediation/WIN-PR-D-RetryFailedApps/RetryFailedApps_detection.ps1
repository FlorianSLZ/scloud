<#
.SYNOPSIS
    Script to detect failed Win32 app installations managed by Microsoft Intune

.DESCRIPTION
    This script identifies failed Intune-managed Win32 application installations on a device 
    and trigers the remediation with the exit code 1.

.NOTES
    Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
    Version: 1.0

    Changelog:
    - 2024-08-15: 1.0 Initial version
    
#>


# Function to search for registry entries related to failed Win32 apps
function Search-FailedApps {
    # Define the registry path where Intune tracks Win32 app enforcement states
    $KeyPath = 'HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps'

    # Check if the registry key exists
    if (Test-Path -Path $KeyPath) {
        # Get all subkeys under the Win32Apps path
        $SubKeys = Get-ChildItem -Path $KeyPath
        
        # Array to store failed apps
        $FailedApps = @()

        # Loop through each app's registry key
        foreach ($SubKey in $SubKeys) {
            # Get the value of the EnforcementStateMessage property
            $EnforcementStateMessage = Get-ItemProperty -Path $SubKey.PSPath -Name "EnforcementStateMessage" -ErrorAction SilentlyContinue
            
            # Check if the EnforcementStateMessage contains an error code that indicates failure (not 0 or 3010)
            if ($EnforcementStateMessage -and $EnforcementStateMessage -notmatch '"ErrorCode":0' -and $EnforcementStateMessage -notmatch '"ErrorCode":3010') {
                # Collect information about the failed app
                $FailedApp = @{
                    "AppID" = $SubKey.Name
                    "EnforcementStateMessage" = $EnforcementStateMessage
                }
                # Add the failed app to the list
                $FailedApps += $FailedApp
            }
        }

        # Output the results
        if ($FailedApps.Count -gt 0) {
            Write-Output "Failed applications detected:"
            $FailedApps | ForEach-Object { Write-Output "AppID: $($_.AppID), Error: $($_.EnforcementStateMessage)" }
            return $true
        }
        else {
            Write-Output "No failed applications detected."
            return $false
        }
    }
    else {
        Write-Output "The registry path for Intune Win32 apps does not exist. No apps detected."
        return $false
    }
}

# Call the function to detect failed apps
$Failed = Search-FailedApps

# If failed apps are detected, exit with 1 to trigger remediation
if ($Failed) {
    exit 1
} else {
    exit 0
}
