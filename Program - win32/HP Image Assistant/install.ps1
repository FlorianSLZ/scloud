$PackageName = "HPImageAssistant"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force
$ErrorActionPreference = 'Stop'

try{
    Start-Process "hp-hpia-5.1.7.exe" -ArgumentList "/s /e /f ""$Env:Programfiles\HPImageAssistant""" -Wait
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
