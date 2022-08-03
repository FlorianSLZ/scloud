$PackageName = "ReInstall_OneDrive"

$Path_4Log = "$ENV:Programfiles\_MEM"
Start-Transcript -Path "$Path_4Log\Log\uninstall\$ProgramName-install.log" -Force

Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

Stop-Transcript
