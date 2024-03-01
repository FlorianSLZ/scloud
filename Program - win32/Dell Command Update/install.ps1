$PackageName = "Dell-Command-Update"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

try{
	# Search for UWP App edition and undinstall
	$DellCUPackage = Get-Package "Dell Command*" -ErrorAction SilentlyContinue
	if($DellCUPackage){$DellCUPackage | Uninstall-Package -Force}

	# install EXE edition
    Start-Process "Dell-Command-Update-Application_4R78G_WIN_5.2.0_A00.EXE" -ArgumentList "/s" -Wait

}catch{
    Write-Error $_
}

Stop-Transcript
