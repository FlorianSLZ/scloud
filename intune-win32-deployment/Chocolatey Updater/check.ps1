$PackageName = "4net-ChocoUpgradeAll"
$Version = 5

# Check if Task exist with correct version
$Task_Name = "$PackageName - $env:username"
$Task_existing = Get-ScheduledTask -TaskName $Task_Name -ErrorAction SilentlyContinue
if($Task_existing.Description -like "Version $Version*"){
    Write-Host "Found it!"
    exit 0
}else{exit 1}