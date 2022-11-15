Param
  (
    [parameter(Mandatory=$false)]
    [String[]]
    $param
  )
  
$ProgramName = "WINGETPROGRAMID"
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$ProgramName-install.log" -Force -Append

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=machine $param

Stop-Transcript
