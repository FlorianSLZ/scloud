$ProgramName = "WINGETPROGRAMID"

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){
    Write-Error "Winget not installed"
}else{
    $wingetPrg_Existing = & $winget_exe list --id $ProgramName --exact --accept-source-agreements
        if ($wingetPrg_Existing -like "*$ProgramName*"){
        Write-Host "Found it!"
    }
}
