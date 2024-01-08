$wingetID = "Notepad++.Notepad++"

# Resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){
    Write-Error "Winget not installed"
}else{
    $wingetPrg_Existing = & $winget_exe list --id $wingetID --exact --accept-source-agreements
        if ($wingetPrg_Existing -like "*$wingetID*"){
        Write-Host "Found it!"
    }
}
