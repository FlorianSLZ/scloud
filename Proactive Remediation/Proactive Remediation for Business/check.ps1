$PackageName = "PR4Business"
$Version = 1

# Check if Task exist with correct version
$task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
if($task_existing.Description -like "Version $Version*"){
    Write-Host "Found it!"
    exit 0
}else{exit 1}