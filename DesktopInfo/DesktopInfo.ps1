$Prg_path = "$Env:Programfiles\DesktopInfo"
Start-Transcript -Path "$scriptSavePath\DesktopInfo-lastrun.log" -Force

Write-Host "Starte DesktopInfo"
Start-Process -FilePath "$Prg_path\DesktopInfo64.exe" -ArgumentList "/ini=hostname.ini"

Stop-Transcript

