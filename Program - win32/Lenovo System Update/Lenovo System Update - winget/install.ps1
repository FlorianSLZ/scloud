Param
  (
    [parameter(Mandatory=$false)]
    [String[]]
    $param
  )
  
$ProgramName = "Lenovo.SystemUpdate"
$Path_4Log = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$ProgramName-install.log" -Force


#Get WinGet Path (system)
$ResolveWingetPath = Resolve-Path "$env:ProgramFiles\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if ($ResolveWingetPath) {
    #If multiple versions (when pre-release versions are installed), pick last one
    $WingetPath = $ResolveWingetPath[-1].Path
    $Script:Winget = "$WingetPath\winget.exe"
}else{
    Write-Error "Winget not installed!"
    exit 1
}


& "$Winget" install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope Machine $param

Stop-Transcript
