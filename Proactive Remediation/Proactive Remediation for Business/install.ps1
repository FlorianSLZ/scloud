$PackageName = "PR4Business"

$Path_4Log = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-install.log" -Force

##########################################################################
#   Recurence Data
##########################################################################

$Schedule_Frequency = "" # Once, Hourly, Daily, AtLogon
$Schedule_RepeatInterval = "" # Number
$Schedule_StartDate = "2022.01.30" # YYYY.MM.DD
$Schedule_StartTime = "18.30" # 24h format

##########################################################################


try{
    # Check if Task exist with correct version
    $task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
    if($task_existing.Description -like "Version $Version*"){
        $detection = .\detection.ps1
        if($detection -ep 1){.\remediation.ps1}
    }else{
        # script path
        $script_path = "$Path_4Log\Data\$PackageName.ps1"
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force

        # Register scheduled task to run at startup
        $schtaskDescription = "Version $Version"
        switch ($Schedule_Frequency)                         
        {                        
            "Once"      {$trigger = New-ScheduledTaskTrigger -Once -At }                        
            "Hourly"    {$trigger = New-ScheduledTaskTrigger -AtStartup}                        
            "Daily"     {$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval $Schedule_RepeatInterval -At 3am}
            "AtLogon"   {$trigger = New-ScheduledTaskTrigger -AtLogon}   
            Default     {Write-Error "Wrong frequency declaration."}                        
        }  
        
        $principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$script_path`""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $PackageName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force
    }


}catch{
    Write-Error $_
}

Stop-Transcript


# Validation
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\