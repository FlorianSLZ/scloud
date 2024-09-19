<#
.SYNOPSIS
    Cleans the registry for failed Intune Win32 Apps

.DESCRIPTION
    This script identifies failed Intune-managed Win32 application installations on a device 
    and resets their status by removing related registry entries, forcing Microsoft Intune to retry the installations.

.NOTES
    Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
    Version: 1.1

    Changelog:
    - 2022-07-25: 1.0 Initial version by Rudo Oms
    - 2024-08-15: 1.1 Simplification
    
#>

Start-Transcript 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\WIN-PR-D-RetryFailedApps_remediation.log'


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

<#
    .SYNOPSIS
    Retrieves the last hash value for a specific user and app ID.
    
    .DESCRIPTION
    This function gets the LastHashValue property from the registry for a given user and app ID.

    .PARAMETER userObjectId
    The object ID of the user.

    .PARAMETER appId
    The ID of the app.

    .OUTPUTS
    The last hash value as a string.
#>
function Get-LastHashValue {
    param (
        [string]$userObjectId,
        [string]$appId
    )

    $reportingKeyPath = "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\Reporting\$userObjectId\$appId\ReportCache\$userObjectId"
    if (Test-Path -Path $reportingKeyPath) {
        $reportingKey = Get-ItemProperty -Path $reportingKeyPath -Name LastHashValue -ErrorAction SilentlyContinue
        return $reportingKey.LastHashValue
    }

    return $null
}

<#
    .SYNOPSIS
    Removes the registry keys for a failed app installation.
    
    .DESCRIPTION
    This function removes the registry keys associated with a failed app installation to trigger a reinstallation attempt.

    .PARAMETER userObjectId
    The object ID of the user.

    .PARAMETER appId
    The ID of the app.

    .PARAMETER lastHashValue
    The last hash value for the app.
#>
function Remove-FailedAppRegistryKeys {
    param (
        [string]$userObjectId,
        [string]$appId,
        [string]$lastHashValue
    )

    $pathsToRemove = @(
        "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\$userObjectId\$appId", # App status per user
        "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\Reporting\$userObjectId\$appId", # Reporting key
        "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\Win32Apps\$userObjectId\GRS\$lastHashValue" # GRS using last hash value
    )

    foreach ($path in $pathsToRemove) {
        if (Test-Path -Path $path) {
            Remove-Item -Path $path -Recurse -Force
            Write-Host "Removed registry key: $path"
        }
        else {
            Write-Host "Registry key not found: $path"
        }
    }
}

<#
    .SYNOPSIS
    Retrieves the username from an object ID.
    
    .DESCRIPTION
    This function maps a user object ID to a username by searching the registry.

    .PARAMETER ObjectID
    The object ID of the user.

    .OUTPUTS
    The username as a string.
#>
function Get-UsernameFromObjectID {
    param (
        [string]$ObjectID
    )

    $userSIDs = Get-ChildItem -Path 'Registry::HKEY_USERS\'

    foreach ($userSID in $userSIDs) {
        $identityKeyPath = "Registry::HKEY_USERS\$($userSID.PSChildName)\Software\Microsoft\Office\16.0\Common\Identity"
        if (Test-Path -Path $identityKeyPath) {
            $identityKey = Get-ItemProperty -Path $identityKeyPath
            if ($identityKey.ConnectedAccountWamAad -eq $ObjectID) {
                return $identityKey.ADUserName
            }
        }
    }

    return $null
}

#### SCRIPT ENTRY POINT ####

# Get the failed Win32 app states
$failedStates = Get-FailedWin32AppStates


# Process each failed state
foreach ($state in $failedStates) {
    # Parse the subkey path to extract User and App ID
    $subKeyPath = $state.SubKeyPath -replace 'HKLM:\\', ''
    $splitPath = $subKeyPath -split '\\'
    $userObjectId = $splitPath[6]
    $appId = $splitPath[7]

    # Get the username
    $userName = Get-UsernameFromObjectID -ObjectID $userObjectId

    # Get the LastHashValue
    $lastHashValue = Get-LastHashValue -userObjectId $userObjectId -appId $appId

    if ($lastHashValue) {
        # Remove the registry keys including the GRS keys using LastHashValue
        Remove-FailedAppRegistryKeys -userObjectId $userObjectId -appId $appId -lastHashValue $lastHashValue
    }
    else {
        Remove-FailedAppRegistryKeys -userObjectId $userObjectId -appId $appId
    }
}

# If any failures were found, restart the Intune Management Extension
if ($failedStates) {
    Write-Host "Detected $($failedStates.Count) failures."
    Write-Host "Restarting Intune Management Extension service..."
    Restart-Service -Name 'IntuneManagementExtension' -Force -PassThru
}

if ($failedStates.Count -eq 0) {
    Write-Host "No failures detected." -ForegroundColor Green
} 


Stop-Transcript
