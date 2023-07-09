$PackageName = "DesktopInfo"
$Prg_path = "$Env:Programfiles\DesktopInfo"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Remove-Item -Path "$Prg_path" -Force -Confirm:$false -Recurse
Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

Stop-Transcript