$schtaskName = "Windows Package Manager - UPDATER"
$Version = "1"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -like $schtaskName }
if($taskExists -and ($taskExists.Description -like "*V$Version*")) {
    Write-Host "Found it!"
}