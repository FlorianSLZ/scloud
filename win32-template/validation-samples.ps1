######################################################################################################################
# Program EXE/File exists
######################################################################################################################
$ProgramPath = Test-Path "C:\Program Files\XXXXX\XXXXXX.exe"

if($ProgramPath){
    Write-Host "Found it!"
}

######################################################################################################################
# Validation File exists with content
######################################################################################################################
$PackageName = "PackageXY"
$Version = "1"
$ProgramVersion_current = Get-Content -Path "$Env:Programfiles\scloud\EndpointManager\Validation\$PackageName"

if($ProgramVersion_current -eq $Version){
    Write-Host "Found it!"
}

# command to create a validation file:
New-Item -Path "$Env:Programfiles\scloud\EndpointManager\Validation\$PackageName" -ItemType "file" -Force -Value $Version


######################################################################################################################
# Program EXE with target Version
######################################################################################################################
$ProgramPath = "C:\Program Files\XXXXX\XXXXXX.exe"
$ProgramVersion_target = '1.0.2' 
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -eq $ProgramVersion_target){
    Write-Host "Found it!"
}

######################################################################################################################
# Program EXE with target Version or higher
######################################################################################################################
$ProgramPath = "C:\Program Files\XXXXX\XXXXXX.exe"
$ProgramVersion_target = '1.0.2' 
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion

if($ProgramVersion_current -ge [System.Version]$ProgramVersion_target){
    Write-Host "Found it!"
}

######################################################################################################################
# Program EXE with target Version and registry key
######################################################################################################################
$ProgramVersion_target = '1.0.2' 
$ProgramPath = "C:\Program Files\XXXXX\XXXXXX.exe"
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion
$RegPath = "HKLM:\SOFTWARE\xxxxx\xxx" 
$RegContent = Get-ItemProperty -Path $RegPath

if(($ProgramVersion_current -eq $ProgramVersion_target) -and ($RegContent)){
    Write-Host "Found it!"
}

######################################################################################################################
# Registry Key
######################################################################################################################
$RegPath = 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{SCLOUD00-3E57-3F0B-9332-48A0A5671812}'
$Version = '2022,01,19'

$RegContent = Get-ItemProperty -Path $RegPath
if($RegContent.Version -eq $Version){
  Write-Host "Found it!"
}

######################################################################################################################
# Scheduled Task
######################################################################################################################
$PackageName = "TaskNameXY"
$task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
if($task_existing){
      Write-Host "Found it!"
}

######################################################################################################################
# Scheduled Task with Version
######################################################################################################################
$PackageName = "TaskNameXY"
$Version = "1"
$task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
if($task_existing.Description -like "Version $Version*"){
      Write-Host "Found it!"
}
    <#
        # EXAMPLE Register scheduled task to run at startup
        $schtaskDescription = "Version $Version"
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$script_path`""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $PackageName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force
    #>
