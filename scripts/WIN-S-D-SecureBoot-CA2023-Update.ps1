<#
.SYNOPSIS
    Intune Platform Script to check and remediate Secure Boot CA 2023 certificate update.

.DESCRIPTION
    Checks if Secure Boot is enabled and if the CA 2023 update has been applied.
    If not started, sets the AvailableUpdates registry trigger and starts the scheduled task.
    Designed to run as a single Intune Platform Script (not a remediation).

.NOTES
  Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
  Version: 1.0
  Run As: System 
  Created: 2026-03-13

#>

$ScriptName = "WIN-S-D-SecureBoot-CA2023-Update"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$ScriptName.log" -Force


$AvailableUpdatesValue = 0x5944
$ScheduledTaskName = "\Microsoft\Windows\PI\Secure-Boot-Update"


try {
   
    # Check Secure Boot
    try { $sbEnabled = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue } catch { $sbEnabled = $false }
    if (-not $sbEnabled) {
        Write-Warning "Secure Boot is disabled, cannot proceed."
        Exit 1
    }

    # Read current status
    $servicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"
    $sbPath        = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
    $status    = (Get-ItemProperty -Path $servicingPath -Name "UEFICA2023Status" -ErrorAction SilentlyContinue).UEFICA2023Status
    $capable   = (Get-ItemProperty -Path $servicingPath -Name "WindowsUEFICA2023Capable" -ErrorAction SilentlyContinue).WindowsUEFICA2023Capable
    $available = (Get-ItemProperty -Path $sbPath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates

    Write-Host "Status=$status, Capable=$capable, AvailableUpdates=$available"

    switch ($status) {
        "Updated" {
            if ($capable -eq 2) {
                Write-Host "Secure Boot CA 2023 update complete. No action needed."
            } else {
                Write-Warning "Status is Updated but Capable=$capable (expected 2)."
            }
        }
        "InProgress" {
            Write-Host "Update in progress, waiting for reboot or task completion."
        }
        "NotStarted" {
            if (($available -band $AvailableUpdatesValue) -eq $AvailableUpdatesValue) {
                Write-Host "Trigger already set, waiting for task or reboot."
            } else {
                Set-ItemProperty -Path $sbPath -Name "AvailableUpdates" -Value $AvailableUpdatesValue -Type DWord
                Write-Host ("AvailableUpdates set to 0x{0:X}" -f $AvailableUpdatesValue)
                Start-ScheduledTask -TaskName $ScheduledTaskName
                Write-Host "Scheduled task triggered. Reboot may be required."
            }
        }
        default {
            Write-Warning "Unknown UEFICA2023Status: $status"
        }
    }
    Exit 0
}
catch {
    Write-Error "Unexpected error: $_"
    Exit 1
}

Stop-Transcript
