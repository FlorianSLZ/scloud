$PackageName = "run-once"
$Version = "1"

$Path_local = "$Env:Programfiles\MEM"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-script.log" -Force
try{
    # Check if Task exist with correct version
    $task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
    if($task_existing.Description -like "Version $Version*"){


        ############################################################################################
        #   YOUR CODE TO RUN ONCE

        Write-Host "GUGUS :)"

        #   END RUN ONCE CODE
        ############################################################################################

        # Delete ScheduledTask
        Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

        # Delete Script
        Remove-Item -Path $MyInvocation.MyCommand.Source

    }else{
        # script path
        $script_path = "$Path_local\Data\$PackageName.ps1"
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force
        
        # Register scheduled task to run at startup
        $schtaskDescription = "Version $Version"
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$script_path`""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $PackageName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force
    }
}catch{
    Write-Error $_
}

Stop-Transcript