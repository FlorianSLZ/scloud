<#
.DESCRIPTION
Checks if the recovery partition has more than 500 MB free space.
Useful to validate if enough space is available for enabling features like BitLocker or updating recovery images.

.AUTHOR
Florian Salzmann
#>

$freePartitionSpace = 524288000  # bytes (500 MB = 524288000 Bytes)

Try {
    $systemDrive = $null
    $computerDisks = Get-PhysicalDisk -ErrorAction Stop

    foreach ($computerDisk in $computerDisks) {
        $diskPartitions = Get-Partition -DiskNumber $computerDisk.DeviceId -ErrorAction SilentlyContinue
        if ($diskPartitions -and ($diskPartitions | Where-Object { $_.DriveLetter -eq 'C' })) {
            $systemDrive = $computerDisk
            break
        }
    }

    if (-not $systemDrive) {
        Write-Output "System drive not found."
        Exit 1000
    }

    $recPartition = Get-Partition -DiskNumber $systemDrive.DeviceId | Where-Object { $_.Type -eq 'Recovery' }

    if (-not $recPartition) {
        Write-Output "Recovery partition not found."
        Exit 2000
    }

    $recVolume = Get-Volume -Partition $recPartition

    if ($recVolume.SizeRemaining -le $freePartitionSpace) {
        Write-Output ("Recovery Partition Free Space {0:N2} MB is smaller than required {1:N2} MB" -f ($recVolume.SizeRemaining / 1MB), ($freePartitionSpace / 1MB))
        Exit 1
    }
    else {
        Write-Output ("Recovery Partition Free Space {0:N2} MB is larger than required {1:N2} MB" -f ($recVolume.SizeRemaining / 1MB), ($freePartitionSpace / 1MB))
        Exit 0
    }
}
Catch {
    Write-Output "Error occurred: $_"
    Exit 3000
}
