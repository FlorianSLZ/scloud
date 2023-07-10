try{
	$EXE_url = "https://cmi-bildung.ch/lo/dateien/easy/lo_desktop_windows.exe"
	$EXE_meta = Invoke-WebRequest -method "Head" $EXE_url | Select Headers -ExpandProperty Headers

	$EXE_onlineDT = [DateTime]::ParseExact($($EXE_meta."Last-Modified"), "ddd, dd MMM yyyy HH:mm:ss 'GMT'", [System.Globalization.CultureInfo]::InvariantCulture)
	$EXE_onlineDTS = $EXE_onlineDT.ToString("yyyy-MM-dd")

	$EXE_uninstall = Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object{$_.DisplayName -eq "LehrerOffice Desktop"}
	if(!$EXE_uninstall){
		Write-Output "LehrerOffice not installed"
		exit 1
	}
	$EXE_installDT = [DateTime]::ParseExact($($EXE_uninstall.InstallDate), "yyyyMMdd", $null)
	$EXE_installDTS = $EXE_installDT.ToString("yyyy-MM-dd")

	$UpdateDelay = 7
	if($EXE_onlineDTS -gt $(Get-Date).AddDays(-$UpdateDelay).ToString("yyyy-MM-dd")){
		Write-Output "Update available, but not more than $UpdateDelay days"
		exit 0
	}

	if($EXE_onlineDTS -gt $EXE_installDTS){
		Write-Output "LehrerOffice update available"
		exit 1
	}else{
		Write-Output "LehrerOffice is up-to-date"
		exit 0
	}

}catch{
	Write-Error $_
}
