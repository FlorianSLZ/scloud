<#
.SYNOPSIS
    Intune Remediation Detection: Check Secure Boot CA 2023 certificate update status.

.DESCRIPTION
    Returns Compliant (exit 0) if the update is complete or in progress.
    Returns Non-Compliant (exit 1) if the update has not started or Secure Boot is disabled. 

.NOTES
  Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
  Version: 1.0
  Run As: System 
  Created: 2026-03-13
#>

$AvailableUpdatesValue = 0x5944

try {

    # Check Secure Boot
    try { $sbEnabled = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue } catch { $sbEnabled = $false }
    if (-not $sbEnabled) {
        Write-Output "Non-Compliant: Secure Boot is disabled."
        Exit 1
    }

    # Read current status
    $servicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"
    $sbPath        = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
    $status    = (Get-ItemProperty -Path $servicingPath -Name "UEFICA2023Status" -ErrorAction SilentlyContinue).UEFICA2023Status
    $capable   = (Get-ItemProperty -Path $servicingPath -Name "WindowsUEFICA2023Capable" -ErrorAction SilentlyContinue).WindowsUEFICA2023Capable
    $available = (Get-ItemProperty -Path $sbPath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates

    switch ($status) {
        "Updated" {
            if ($capable -eq 2) {
                Write-Output "Compliant: Status=$status, Capable=$capable"
                Exit 0
            } else {
                Write-Output "Non-Compliant: Status=$status but Capable=$capable (expected 2)"
                Exit 1
            }
        }
        "InProgress" {
            Write-Output "Compliant: Update in progress (AvailableUpdates=$available)"
            Exit 0
        }
        "NotStarted" {
            if (($available -band $AvailableUpdatesValue) -eq $AvailableUpdatesValue) {
                Write-Output "Compliant: Trigger set, waiting for task or reboot (AvailableUpdates=$available)"
                Exit 0
            } else {
                Write-Output "Non-Compliant: Status=$status, AvailableUpdates=$available - needs remediation"
                Exit 1
            }
        }
        default {
            Write-Output "Non-Compliant: Unknown UEFICA2023Status=$status, AvailableUpdates=$available"
            Exit 1
        }
    }
}
catch {
    Write-Output "Non-Compliant: Unexpected error - $_"
    Exit 1
}
