$PackageName = "choco-upgrade"
$Version = "1"
$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

# Check choco.exe 
$localprograms = C:\ProgramData\chocolatey\choco.exe list --localonly
if ($localprograms -like "*Chocolatey*"){
    Write-Host "Chocolatey installed"
}else{
    Write-Host "Chocolatey not Found!"
    break
}

# Scheduled Task for "choco upgrade -y"
$schtaskName = "4net - Choco Upgrade All"
$schtaskDescription = "Upgade der mit Chocolaty verwalteten Paketen. V$($Version)"
$trigger1 = New-ScheduledTaskTrigger -AtStartup
$trigger2 = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Wednesday -At 8pm
$principal= New-ScheduledTaskPrincipal -UserId 'SYSTEM'
$action = New-ScheduledTaskAction –Execute "C:\ProgramData\chocolatey\choco.exe" -Argument 'upgrade all -y'
$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger1,$trigger2 -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force


Stop-Transcript


