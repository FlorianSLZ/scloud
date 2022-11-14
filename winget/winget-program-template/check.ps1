$ProgramName = "WINGETPROGRAMID"

# resolve winget
$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }
$wingetexe = $ResolveWingetPath 

$wingetPrg_Existing = & $wingetexe list --id $ProgramName --exact --accept-source-agreements
    if ($wingetPrg_Existing -like "*$ProgramName*"){
    Write-Host "Found it!"
}
