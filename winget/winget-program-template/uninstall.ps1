$ProgramName = "WINGETPROGRAMID"
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\uninstall\$ProgramName-uninstall.log" -Force

# resolve winget
$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }
$wingetexe = $ResolveWingetPath

& $wingetexe uninstall --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements

Stop-Transcript
