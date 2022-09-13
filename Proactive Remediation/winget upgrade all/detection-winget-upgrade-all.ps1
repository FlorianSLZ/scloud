$Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe")

if ($(&$winget upgrade) -gt 3) {
	Write-Host "Upgrade(s) available."
	exit 1 # upgrade available, remediation needed
}
else {
		Write-Host "No Upgrade available"
		exit 0 # no upgared, no action needed
}
