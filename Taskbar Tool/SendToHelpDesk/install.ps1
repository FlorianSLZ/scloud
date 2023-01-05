$PackageName = "HelpdeskInfo"
$Version = 1

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

try{
    $SysT_Name = "Helpdesk Info"
    $SysT_Folder = "$env:Programdata\$SysT_Name"

    # Task Name & Description
    $schtaskName = "$PackageName"
    $schtaskDescription = "Version $Version"

    # Check if Task exist with correct version
    $task_existing = Get-ScheduledTask -TaskName $schtaskName -ErrorAction SilentlyContinue
    if($task_existing.Description -like "Version $Version*"){
        Write-Warning "$PackageName already installed with target version: $Version"
        break
    }else{
       if(!$(Test-Path $SysT_Folder)){
            New-Item -Type directory -Path $SysT_Folder -Force
        }

        Copy-Item ".\*" $SysT_Folder -Force -Recurse

        # Register scheduled task to run at startup
        $trigger = New-ScheduledTaskTrigger -AtLogon 
        $principal= New-ScheduledTaskPrincipal -GroupId S-1-5-32-545
       	$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle hidden -ExecutionPolicy Bypass -Command ""$SysT_Folder\HelpdeskInfo.ps1"""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force

    }


}catch{
    Write-Error $_
}

Stop-Transcript

