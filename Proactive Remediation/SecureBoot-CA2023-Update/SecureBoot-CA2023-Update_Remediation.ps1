<#
.SYNOPSIS
    Intune Remediation: Trigger Secure Boot CA 2023 certificate update.

.DESCRIPTION
    Sets the AvailableUpdates registry trigger and starts the scheduled task.
    Only acts if UEFICA2023Status is NotStarted and the trigger is not yet set.

.NOTES
  Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
  Version: 1.0
  Run As: System 
  Created: 2026-03-13

#>

$AvailableUpdatesValue = 0x5944
$ScheduledTaskName = "\Microsoft\Windows\PI\Secure-Boot-Update"

try {

    # Check Secure Boot
    try { $sbEnabled = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue } catch { $sbEnabled = $false }
    if (-not $sbEnabled) {
        Write-Output "Failed: Secure Boot is disabled."
        Exit 1
    }

    # Read current status
    $servicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"
    $sbPath        = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot"
    $status    = (Get-ItemProperty -Path $servicingPath -Name "UEFICA2023Status" -ErrorAction SilentlyContinue).UEFICA2023Status
    $available = (Get-ItemProperty -Path $sbPath -Name "AvailableUpdates" -ErrorAction SilentlyContinue).AvailableUpdates

    if ($status -eq "NotStarted") {
        if (($available -band $AvailableUpdatesValue) -eq $AvailableUpdatesValue) {
            Write-Output "Remediated: Trigger already set (AvailableUpdates=$available), waiting for task or reboot."
            Exit 0
        }
        # Set trigger
        Set-ItemProperty -Path $sbPath -Name "AvailableUpdates" -Value $AvailableUpdatesValue -Type DWord
        Write-Output ("Remediated: AvailableUpdates set to 0x{0:X}" -f $AvailableUpdatesValue)
        # Start scheduled task
        Start-ScheduledTask -TaskName $ScheduledTaskName
        Write-Output "Remediated: Scheduled task triggered. Reboot may be required."
        Exit 0
    }
    elseif ($status -eq "Updated") {
        Write-Output "Remediated: Already updated, no action needed."
        Exit 0
    }
    elseif ($status -eq "InProgress") {
        Write-Output "Remediated: Already in progress, no action needed."
        Exit 0
    }
    else {
        Write-Output "Failed: Unknown UEFICA2023Status=$status, AvailableUpdates=$available"
        Exit 1
    }
}
catch {
    Write-Output "Failed: Unexpected error - $_"
    Exit 1
}
