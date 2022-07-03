$PackageName = "PR4Business"
$Version = 1

$Path_4Log = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-install.log" -Force

##########################################################################
#   Recurence Data
##########################################################################

$Schedule_Frequency = "Hourly"       # Once, Hourly, Daily, AtLogon
$Schedule_RepeatInterval = "1"      # Number            (for Daily and Hourly)
$Schedule_StartDate = "2023-01-30"  # YYYY.MM.DD        (for Once)
$Schedule_StartTime = "8am"         # ex 8am or 5pm     (for Once, Hourly, Daily)

##########################################################################

try{
    # local Path
    $Path_PR = "$Path_4Log\Data\PR_$PackageName"

    # Check if Task exist with correct version
    $task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
    if($task_existing.Description -like "Version $Version*"){
        cd $Path_PR
        .\detection.ps1
        if($LASTEXITCODE -ne 0){
            Write-Host "Detection positiv, remediation starts now"
            .\remediation.ps1
            }else{
                Write-Host "Detection negativ, no further action needed"
            }
    }else{
        # path declaration / creation
        New-Item -path $Path_PR -ItemType Directory -Force
        $Path_script = "$Path_PR\$PackageName.ps1"
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $Path_script -Force

        # copy/safe detection- and remediation script
        Copy-Item detection.ps1 -Destination $Path_PR -Force
        Copy-Item remediation.ps1 -Destination $Path_PR -Force

        # Register scheduled task to run at startup
        $schtaskDescription = "Version $Version"
        switch ($Schedule_Frequency)                         
        {                        
            "Once"      {$trigger = New-ScheduledTaskTrigger -Once -At $(Get-Date "$Schedule_StartDate $Schedule_StartTime")}                        
            "Hourly"    {$trigger = New-ScheduledTaskTrigger -Once -At $Schedule_StartTime -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Hours $Schedule_RepeatInterval)}                     
            "Daily"     {$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval $Schedule_RepeatInterval -At $Schedule_StartTime}
            "AtLogon"   {$trigger = New-ScheduledTaskTrigger -AtLogon}   
            Default     {Write-Error "Wrong frequency declaration."}                        
        }  
        
        $principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$Path_script`""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $PackageName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force

        # Start Task if Frequency is Hourly
        if($Schedule_Frequency -eq "Hourly"){Start-ScheduledTask $PackageName}
    
    }


}catch{
    Write-Error $_
}

Stop-Transcript


# Validation
#Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\