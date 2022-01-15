$ProgramName = "4net - Choco Upgrade All"

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $ProgramName }
if($taskExists) {
    Write-Host "Found it!"
}