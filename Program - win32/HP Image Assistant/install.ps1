$PackageName = "HPImageAssistant"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

try{
    Start-Process "hpia.exe" -ArgumentList "/s /e /f ""$Env:Programfiles\HPImageAssistant""" -Wait
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
