<#
.SYNOPSIS
  Detection script for low disk space before Windows 11 upgrade.

.DESCRIPTION
  Checks if drive C: has at least 30 GB of free space.
  If not, it calculates the combined size of the Downloads folder and Recycle Bin.
  If these together exceed 500 MB, the remediation will be triggered to help the user clean up.

.NOTES
  Author: Florian Salzmann | @FlorianSLZ | https://scloud.work
  Version: 1.0
  Run As: User 
  Created: 2025-10-08

#>


$MinGBFree    = 30
$MinReclaimMB = 500

# Free space on C:
try {
    $freeBytes = (Get-PSDrive -Name C -ErrorAction Stop).Free
} catch {
    Write-Output "Could not read free space on C:"
    exit 1
}

if ($freeBytes -ge ($MinGBFree * 1GB)) {
    Write-Output "OK. Free space is above $MinGBFree GB."
    exit 0
}

# Downloads size
$downloadsPath = Join-Path $env:USERPROFILE "Downloads"
$downloadBytes = 0
if (Test-Path -LiteralPath $downloadsPath) {
    $downloadBytes = (Get-ChildItem -LiteralPath $downloadsPath -Recurse -Force -File -ErrorAction SilentlyContinue | Measure-Object -Sum Length).Sum
}

# Recycle Bin size
$RecycleBinBytes = 0
try {
    $shell = New-Object -ComObject Shell.Application
    $rb    = $shell.Namespace('shell:RecycleBinFolder')
    if ($rb) {
        foreach ($item in $rb.Items()) { try { $RecycleBinBytes += [int64]$item.Size } catch {} }
    }
} catch {}

$combinedBytes = [int64]$downloadBytes + [int64]$RecycleBinBytes
$combinedMB    = [math]::Round($combinedBytes / 1MB, 0)


if ($combinedBytes -ge ($MinReclaimMB * 1MB)) {
    Write-Output "Low space. Combined Downloads + Recycle Bin = $combinedMB MB."
    exit 1
}

Write-Output "Low space, BUT Combined Downloads + Recycle Bin = $combinedMB MB."
exit 0
