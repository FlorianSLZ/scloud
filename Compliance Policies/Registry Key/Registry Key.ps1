# Check a registry key
$RegistryPath = "HKLM:\SOFTWARE\CustomSecurity"
$propertyName = "OnboardingState"

$output = @{
    RegistryCheck = (Get-ItemProperty -Path $RegistryPath -Name $propertyName).$propertyName
}

return $output | ConvertTo-Json -Compress