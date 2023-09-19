# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

# check exe and functionality
if ($winget_exe){
    if(& $winget_exe -v){
        Write-Host "Found it!"
    }
}
