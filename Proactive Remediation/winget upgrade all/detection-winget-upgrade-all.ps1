# resolve and navigate to winget.exe
$Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe")

if ($(&$winget upgrade) -gt 3) {
	Write-Host "Upgrade(s) aviable."
	exit 1 # upgrade aviable, remediation needed
}
else {
		Write-Host "No Upgrade aviable"
		exit 0 # no upgared, no action needed
}
