$TaskName = "Custom Compliance check-in"
$repeat = (New-TimeSpan -Minutes 15)
$trigger = New-JobTrigger -Once -At (Get-Date).Date -RepeatIndefinitely -RepetitionInterval $repeat

$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -encodedcommand UwB0AGEAcgB0AC0AUAByAG8AYwBlAHMAcwAgAC0ARgBpAGwAZQBQAGEAdABoACAAIgBDADoAXABQAHIAbwBnAHIAYQBtACAARgBpAGwAZQBzACAAKAB4ADgANgApAFwATQBpAGMAcgBvAHMAbwBmAHQAIABJAG4AdAB1AG4AZQAgAE0AYQBuAGEAZwBlAG0AZQBuAHQAIABFAHgAdABlAG4AcwBpAG8AbgBcAE0AaQBjAHIAbwBzAG8AZgB0AC4ATQBhAG4AYQBnAGUAbQBlAG4AdAAuAFMAZQByAHYAaQBjAGUAcwAuAEkAbgB0AHUAbgBlAFcAaQBuAGQAbwB3AHMAQQBnAGUAbgB0AC4AZQB4AGUAIgAgAC0AQQByAGcAdQBtAGUAbgB0AEwAaQBzAHQAIAAiAGkAbgB0AHUAbgBlAG0AYQBuAGEAZwBlAG0AZQBuAHQAZQB4AHQAZQBuAHMAaQBvAG4AOgAvAC8AcwB5AG4AYwBjAG8AbQBwAGwAaQBhAG4AYwBlACIACgAKAAoACgA="

Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -User $User -Action $Action -Force 
Set-ScheduledTask -TaskName $TaskName -Settings $(New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)



# dencoded comand:
# Start-Process -FilePath "C:\Program Files (x86)\Microsoft Intune Management Extension\Microsoft.Management.Services.IntuneWindowsAgent.exe" -ArgumentList "intunemanagementextension://synccompliance" 
