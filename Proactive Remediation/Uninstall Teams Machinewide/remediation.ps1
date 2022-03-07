try{
    # Remove Teams Machine-Wide Installer
    Write-Host "Removing Teams Machine-wide Installer" -ForegroundColor Yellow
    $MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}
    $MachineWide.Uninstall()
    Write-Host "Successful removed: Teams Machine-wide Installer" -ForegroundColor Green
    $ProgramName = "microsoft-teams.install"
	$ChocoPrg_Existing = C:\ProgramData\chocolatey\choco.exe list --localonly
		if ($ChocoPrg_Existing -like "*$ProgramName*"){
		Write-Host "Removing $ProgramName from Chocolatey"
        C:\ProgramData\chocolatey\choco.exe uninstall $ProgramName -y
		exit 0 
	}

    # Active Setup for User install

}catch{
    Write-Error "Error while uninstalling Teams Machine-wide Installer"
}
