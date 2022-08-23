$ProgramName = "WINGETPROGRAMID"

# resolve and nacigate to winget
$Path_WingetAll = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if($Path_WingetAll){$Path_Winget = $Path_WingetAll[-1].Path}
cd $Path_Winget

$wingetPrg_Existing = .\winget list --id $ProgramName --exact
    if ($wingetPrg_Existing -like "*$ProgramName*"){
    Write-Host "Found it!"
}
