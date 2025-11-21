<#
.SYNOPSIS
  Checks Secure Boot CA 2023 registry status and, if needed, triggers the update.

.DESCRIPTION
  Based on:
  - "Registry key updates for Secure Boot: Windows devices with IT-managed updates"
  - Secure Boot playbook for certificates expiring in 2026

  Checks:
    - HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\AvailableUpdates (REG_DWORD)
    - HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\HighConfidenceOptOut (REG_DWORD)
    - HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\MicrosoftUpdateManagedOptIn (REG_DWORD)
    - HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing\UEFICA2023Status (REG_SZ)
    - HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing\UEFICA2023Error (REG_DWORD)
    - HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing\WindowsUEFICA2023Capable (REG_DWORD)

  Additional logic:
    - If the update is NOT already done
      AND AvailableUpdates is 0 or not set,
      then set:
        AvailableUpdates = 0x5944  (enterprise "all keys + bootmgr" deployment)

  Exit codes (for use as remediation or health script):
    0 = Device is already updated OR update was successfully triggered
    1 = Error or unexpected state (manual investigation needed)
#>

# Ensure we run as admin (registry path is HKLM)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script should be run with administrative privileges."
}

$basePath      = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
$servicingPath = Join-Path $basePath "Servicing"

function Get-RegValue {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Name
    )

    if (-not (Test-Path $Path)) {
        return $null
    }

    try {
        $props = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
        return $props.$Name
    }
    catch {
        return $null
    }
}

Write-Host "=== Secure Boot - Registry Status (Windows UEFI CA 2023) ===" -ForegroundColor Cyan
Write-Host ""

# Keys under HKLM\...\SecureBoot 
$availableUpdates        = Get-RegValue -Path $basePath      -Name "AvailableUpdates"
$highConfidenceOptOut    = Get-RegValue -Path $basePath      -Name "HighConfidenceOptOut"
$microsoftManagedOptIn   = Get-RegValue -Path $basePath      -Name "MicrosoftUpdateManagedOptIn"

Write-Host "[SecureBoot base path]"
Write-Host "Path: $basePath"
Write-Host ("AvailableUpdates           : {0}" -f ($availableUpdates  -as [int]))
if ($availableUpdates -ne $null) {
    $availableHex = "0x{0}" -f ([Convert]::ToString($availableUpdates,16).ToUpper())
    Write-Host ("  -> Hex                  : {0}" -f $availableHex)
}
Write-Host ("HighConfidenceOptOut      : {0}" -f ($highConfidenceOptOut -as [int]))
Write-Host ("MicrosoftUpdateManagedOptIn: {0}" -f ($microsoftManagedOptIn -as [int]))
Write-Host ""

# Keys under HKLM\...\SecureBoot\Servicing 
$uefiStatus      = Get-RegValue -Path $servicingPath -Name "UEFICA2023Status"
$uefiError       = Get-RegValue -Path $servicingPath -Name "UEFICA2023Error"
$uefiCapable     = Get-RegValue -Path $servicingPath -Name "WindowsUEFICA2023Capable"

Write-Host "[SecureBoot servicing path]"
Write-Host "Path: $servicingPath"
Write-Host ("UEFICA2023Status          : {0}" -f ($uefiStatus  -as [string]))
Write-Host ("UEFICA2023Error           : {0}" -f ($uefiError   -as [int]))
Write-Host ("WindowsUEFICA2023Capable  : {0}" -f ($uefiCapable -as [int]))

if ($uefiCapable -ne $null) {
    switch ($uefiCapable) {
        0 { Write-Host "  -> Capable meaning      : 0 = Certificate NOT in DB" }
        1 { Write-Host "  -> Capable meaning      : 1 = Certificate in DB (2023 CA present)" }
        2 { Write-Host "  -> Capable meaning      : 2 = Certificate in DB AND booting from 2023-signed boot manager" }
        default { Write-Host "  -> Capable meaning      : Unknown value" }
    }
}

if ($uefiError -ne $null -and $uefiError -ne 0) {
    Write-Warning "UEFICA2023Error is non-zero - Secure Boot update reported an error. Check Secure Boot events in the System log."
}
elseif ($uefiError -eq 0) {
    Write-Host "UEFICA2023Error indicates no error (0)."
}
Write-Host ""

# Decide if update is already "done" 
$updateAlreadyDone = $false

if (
    ($uefiStatus -eq "Updated") -or
    ($uefiCapable -eq 2)
) {
    if ($uefiError -eq $null -or $uefiError -eq 0) {
        $updateAlreadyDone = $true
    }
}

if ($updateAlreadyDone) {
    Write-Host "Result: Secure Boot CA 2023 update appears to be fully DEPLOYED on this device." -ForegroundColor Green
}

Write-Warning "Secure Boot CA 2023 update not yet completed (Status/Capable/Error not in 'Updated' state)."

# If not done yet: optionally trigger the deployment via AvailableUpdates 
$triggerValue = 0x5944  # Deploy all needed certificates and 2023 boot manager

if ($availableUpdates -eq $null -or $availableUpdates -eq 0) {
    Write-Host ""
    Write-Host "No AvailableUpdates value set (or zero). Triggering Secure Boot update via registry..." -ForegroundColor Yellow

    try {
        if (-not (Test-Path $basePath)) {
            New-Item -Path $basePath -Force | Out-Null
        }

        New-ItemProperty -Path $basePath -Name "AvailableUpdates" -PropertyType DWord -Value $triggerValue -Force | Out-Null

        # Re-read to confirm
        $availableUpdates = Get-RegValue -Path $basePath -Name "AvailableUpdates"

        if ($availableUpdates -eq $triggerValue) {
            $hex = "0x{0}" -f ([Convert]::ToString($availableUpdates,16).ToUpper())
            Write-Host "Successfully set AvailableUpdates to $hex (0x5944). Secure Boot update will be processed by the OS task." -ForegroundColor Green

            <#
            Optional (for testing / manual runs):
            You can uncomment this block to immediately trigger the scheduled task instead of
            waiting for the regular 12h interval.

            if (Get-ScheduledTask -TaskName "\Microsoft\Windows\PI\Secure-Boot-Update" -ErrorAction SilentlyContinue) {
                Write-Host "Starting scheduled task '\Microsoft\Windows\PI\Secure-Boot-Update'..."
                Start-ScheduledTask -TaskName "\Microsoft\Windows\PI\Secure-Boot-Update"
            }
            #>

            # Script goal reached: update is now triggered
        }
        else {
            Write-Error "Failed to verify AvailableUpdates value after write. Current: $availableUpdates"
        }
    }
    catch {
        Write-Error "Error while setting AvailableUpdates to 0x5944: $_"
    }
}
else {
    $hex = "0x{0}" -f ([Convert]::ToString($availableUpdates,16).ToUpper())
    Write-Host ""
    Write-Host "AvailableUpdates is already non-zero ($hex). Assuming update is already queued or in progress." -ForegroundColor Yellow
    Write-Warning "No change made. Monitor UEFICA2023Status / UEFICA2023Error and event logs for progress."
}
