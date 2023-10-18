$taskName = "Daily Shutdown"
$ShutDownTime = "9PM"
$description = "Shuts computer down daily at $ShutDownTime"

# Create a new task action
$taskAction = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument 'Stop-Computer -Force'

#Create task trigger
$taskTrigger = New-ScheduledTaskTrigger -Daily -At $ShutDownTime

# Register the scheduled task
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description
