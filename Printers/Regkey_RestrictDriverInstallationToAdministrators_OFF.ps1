# Disable limitation: driver installation to admins
$RegistryPath = 'HKLM:\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint'
$Name         = 'RestrictDriverInstallationToAdministrators'
$Value        = '0'
$KeyType      = 'DWord'
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType $KeyType -Force 