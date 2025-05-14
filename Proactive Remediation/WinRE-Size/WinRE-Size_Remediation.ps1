<#
.DESCRIPTION
Extends or replaces the existing Windows Recovery (WinRE) partition when free space is insufficient.
This script disables WinRE, removes the current recovery partition, resizes the preceding partition, and recreates the WinRE partition according to the system's partition style (GPT or MBR).

.AUTHOR
Florian Salzmann
#>

$freePartitionSpace = "500MB"

Try {
    # Run 'reagentc /info' and capture output
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
    $pinfo.FileName = 'reagentc.exe'
    $pinfo.Arguments = '/info'
    $pinfo.RedirectStandardOutput = $true
    $pinfo.UseShellExecute = $false
    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $pinfo
    $p.Start() | Out-Null
    $p.WaitForExit()
    $stdout = $p.StandardOutput.ReadToEnd()

    # Validate that both disk and partition are listed
    if (($stdout -like '*harddisk*') -and ($stdout -like '*partition*')) {
        # Disable WinRE temporarily
        Start-Process 'reagentc.exe' -ArgumentList '/disable' -Wait -NoNewWindow

        # Extract disk and partition numbers
        $diskNum = $stdout.Substring($stdout.IndexOf('harddisk') + 8, 1)
        $recPartNum = $stdout.Substring($stdout.IndexOf('partition') + 9, 1)

        # Resize the partition before the recovery partition
        $prevPartNum = [int]$recPartNum - 1
        $currentSize = (Get-Disk $diskNum | Get-Partition -PartitionNumber $prevPartNum).Size
        Resize-Partition -DiskNumber $diskNum -PartitionNumber $prevPartNum -Size ($currentSize - $freePartitionSpace)

        # Remove the current recovery partition
        Remove-Partition -DiskNumber $diskNum -PartitionNumber $recPartNum -Confirm:$false

        # Prepare diskpart script
        $diskpartScriptPath = Join-Path -Path $env:TEMP -ChildPath 'ResizeREScript.txt'
        $partStyle = (Get-Disk $diskNum).PartitionStyle

        @(
            "sel disk $diskNum"
            if ($partStyle -eq 'GPT') {
                'create partition primary id=de94bba4-06d1-4d40-a16a-bfd50179d6ac'
                'gpt attributes =0x8000000000000001'
            } else {
                'create partition primary id=27'
            }
            'format quick fs=ntfs label="Windows RE tools"'
        ) | Set-Content -Path $diskpartScriptPath -Encoding UTF8

        # Execute diskpart
        Start-Process 'diskpart.exe' -ArgumentList "/s $diskpartScriptPath" -Wait -NoNewWindow -WorkingDirectory $env:TEMP

        # Re-enable WinRE
        Start-Process 'reagentc.exe' -ArgumentList '/enable' -Wait -NoNewWindow

        Write-Output 'Recovery Partition Extended Successfully.'
        Exit 0
    }
    else {
        Write-Output 'Recovery partition not found. Aborting script.'
        Exit 1
    }
}
Catch {
    Write-Output "Unable to update Recovery Partition on the device. Error: $_"
    Exit 2000
}
