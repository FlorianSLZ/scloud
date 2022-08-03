######################################################################################################################
# Scheduled Task
######################################################################################################################
$PackageName = "ReInstall_OneDrive"
$task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
if($task_existing){
      Write-Host "Found it!"
}
