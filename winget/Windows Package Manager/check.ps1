$wingetexe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($wingetexe.count -gt 1){
           $wingetexe = $wingetexe[-1].Path
    }

if ($wingetexe){
    Write-Host "Found it!"
}
