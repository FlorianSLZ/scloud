$PackageName = "winget-updater"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\uninstall\$ProgramName-uninstall.log" -Force

# Remove Task
$schtaskName = "Windows Package Manager - UPDATER"
Unregister-ScheduledTask -TaskName $schtaskName

# Remove local directory
Remove-Item "$Path_local\Data\$PackageName" -Force -Recurse

Stop-Transcript
