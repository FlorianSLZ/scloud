$PackageName = "Dell-Command-Update"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

try{
	# Search for UWP App edition and undinstall
	$DellCUPackage = Get-Package "Dell Command*" -ErrorAction SilentlyContinue
	if($DellCUPackage){$DellCUPackage | Uninstall-Package -Force}

	# install EXE edition
    Start-Process "Dell-Command-Update-Application_T97XP_WIN_4.6.0_A00.EXE" -ArgumentList "/s" -Wait
}catch{
    Write-Error $_
}

Stop-Transcript
