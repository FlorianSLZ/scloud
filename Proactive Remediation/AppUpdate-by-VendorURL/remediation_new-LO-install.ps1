try{
	$EXE_url = "https://cmi-bildung.ch/lo/dateien/easy/lo_desktop_windows.exe"
	$EXE_localInstall = "$env:TEMP\LehrerOffice-installation.exe"
	
	# Download latest EXE
	(New-Object System.Net.WebClient).DownloadFile($EXE_url, $EXE_localInstall)

	# install EXE
	Start-Process $EXE_localInstall -ArgumentList '/VERYSILENT /NORUN /NOCANCEL /LOG="C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LehrerOffice-EXE-install.log"' -Wait

}catch{
	Write-Error $_
}
