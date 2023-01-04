$PackageName = "HelpdeskInfo"
$Version = 1

# Check if Task exist with correct version
$Task_Name = "$PackageName"
$Task_existing = Get-ScheduledTask -TaskName $Task_Name -ErrorAction SilentlyContinue
if($Task_existing.Description -like "Version $Version*"){
    Write-Host "Found it!"
    exit 0
}else{exit 1}