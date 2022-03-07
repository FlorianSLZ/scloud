$PrgInstalled = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}

if (!$PrgInstalled) {
	Write-Host "Teams Machine-Wide Installer is not installed"
	exit 0 # OK
}
else {
		Write-Host "Teams Machine-Wide Installer is installed"
		exit 1 # action needed
}