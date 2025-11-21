<#
.SYNOPSIS
  Intune detection script for Secure Boot CA 2023 update.

.DESCRIPTION
  Returns compliant (exit 0) if Secure Boot CA 2023 appears fully deployed:
    - UEFICA2023Status = "Updated" OR WindowsUEFICA2023Capable = 2
    AND
    - UEFICA2023Error is missing or 0

  Otherwise exits 1 so the remediation script can run.
#>

$servicingPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing"

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


# Check if Secure Boot UEFI database contains the 2023 certificate
try {
    $db = Get-SecureBootUEFI -Name db
    $dbString = [System.Text.Encoding]::ASCII.GetString($db.Bytes)
} catch {
    Write-Output "Error: Unable to read Secure Boot UEFI DB. Device may not support Secure Boot or access is blocked."
}

# Match for the new certificate
$match = $dbString -match 'Windows UEFI CA 2023'

if ($match) {
    Write-Output "Compliant: Windows UEFI CA 2023 is present in the Secure Boot database."
    exit 0
} else {
    Write-Output "Non-Compliant: Windows UEFI CA 2023 not found in the Secure Boot database."
}



$uefiStatus  = Get-RegValue -Path $servicingPath -Name "UEFICA2023Status"
$uefiError   = Get-RegValue -Path $servicingPath -Name "UEFICA2023Error"
$uefiCapable = Get-RegValue -Path $servicingPath -Name "WindowsUEFICA2023Capable"

$updated = $false



if (
    ($uefiStatus -eq "Updated" -or $uefiCapable -eq 2) -and
    ($null -eq $uefiError -or $uefiError -eq 0)
) {
    $updated = $true
}

if ($updated) {
    Write-Output "Secure Boot CA 2023: Update deployed (Status='$uefiStatus', Capable=$uefiCapable, Error=$uefiError)."
    exit 0
}
else {
    Write-Output "Secure Boot CA 2023: Not fully updated yet. Status='$uefiStatus', Capable=$uefiCapable, Error=$uefiError."
    exit 1
}
