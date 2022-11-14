Param
  (
    [parameter(Mandatory=$false)]
    [String[]]
    $param
  )
  
$ProgramName = "WINGETPROGRAMID"
$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$ProgramName-install.log" -Force -Append

# resolve and navigate to winget
$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }
$wingetexe = $ResolveWingetPath

& $wingetexe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=machine $param

Stop-Transcript
