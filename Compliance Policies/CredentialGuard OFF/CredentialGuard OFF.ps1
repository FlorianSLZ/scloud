# Check if Credential Guard is enabled using Get-ComputerInfo
$CredentialGuardEnabled = $false

$SecurityServices = (Get-ComputerInfo | Select-Object -ExpandProperty DeviceGuardSecurityServicesRunning)

if ($SecurityServices -contains "CredentialGuard") {
    $CredentialGuardEnabled = $true
}

$output = @{
    CredentialGuard = $CredentialGuardEnabled
}

return $output | ConvertTo-Json -Compress
