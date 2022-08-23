Param
  (
    [parameter(Mandatory=$false)]
    [String[]]
    $param
  )
  
$ProgramName = "WINGETPROGRAMID"
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$ProgramName-install.log" -Force

# resolve and navigate to winget
$Path_WingetAll = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if($Path_WingetAll){$Path_Winget = $Path_WingetAll[-1].Path}
cd $Path_Winget

.\winget.exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements $param

Stop-Transcript
