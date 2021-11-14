$scriptSavePath = "C:\Program Files\4net\EndpointManager\Program\DesktopInfo"
Start-Transcript -Path "$scriptSavePath\DesktopInfo-lastrun.log" -Force

Write-Host "Starte DesktopInfo"
Start-Process -FilePath "C:\Program Files\4net\EndpointManager\Program\DesktopInfo\DesktopInfo64.exe" -ArgumentList "/ini=hostname.ini"

Stop-Transcript

