$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\uninstall\$ProgramName-uninstall.log" -Force

# Remove Task
$schtaskName = "Chocolatey Upgrade All"
Unregister-ScheduledTask -TaskName $schtaskName

Stop-Transcript