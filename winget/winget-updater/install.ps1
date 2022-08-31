$PackageName = "winget-updater"
$Version = 1

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$ProgramName-install.log" -Force

# Upgrade Script
$upgrade_script_path = "$Path_local\Data\$PackageName\$PackageName.ps1"
$upgrade_script = @("
# resolve and navigate to winget
`$Path_WingetAll = Resolve-Path ""C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe""
if(`$Path_WingetAll){`$Path_Winget = `$Path_WingetAll[-1].Path}
cd `$Path_Winget

.\winget.exe upgrade --query --silent --force --accept-package-agreements --accept-source-agreements --all

")
$upgrade_script | Out-File $(New-Item $upgrade_script_path -Type File -Force)

# Scheduled Task for "winget upgrades"
$schtaskName = "Windows Package Manager - UPDATER"
$schtaskDescription = "Manages the Updates of the Windows Package Manager. V$($Version)"
$trigger1 = New-ScheduledTaskTrigger -AtStartup
$trigger2 = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Wednesday -At 8pm
$principal= New-ScheduledTaskPrincipal -UserId 'SYSTEM'
$action = New-ScheduledTaskAction –Execute "PowerShell.exe" -Argument 'upgrade all -y'
$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger1,$trigger2 -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force


Stop-Transcript


