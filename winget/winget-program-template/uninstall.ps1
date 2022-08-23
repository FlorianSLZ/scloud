$ProgramName = "WINGETPROGRAMID"
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\uninstall\$ProgramName-uninstall.log" -Force

# resolve and navigate to winget
$Path_WingetAll = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if($Path_WingetAll){$Path_Winget = $Path_WingetAll[-1].Path}
cd $Path_Winget

.\winget.exe uninstall --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements

Stop-Transcript
