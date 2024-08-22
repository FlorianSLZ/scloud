$PackageName = "clear-TeamsCache_run-once"
$Version = "1"

$PackagePath = "$Env:ProgramData\Intune-Helper-Data\$PackageName"
Start-Transcript -Path "$Env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName.log" -Force
try{
    # Check if Task exist with correct version
    $task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
    if($task_existing.Description -like "Version $Version*"){


        ############################################################################################
        #   CODE TO RUN ONCE

        # clear Teams cache for all Users
        if(Get-Process Teams -ErrorAction SilentlyContinue){Get-Process Teams | Stop-Process -Force}
        Get-ChildItem "C:\Users\*\AppData\Roaming\Microsoft\Teams\*" -directory | Where name -in ('application cache','blob storage','databases','GPUcache','IndexedDB','Local Storage','tmp') | ForEach{Remove-Item $_.FullName -Recurse -Force }

        #   END RUN ONCE CODE
        ############################################################################################

        # Delete ScheduledTask
        Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

        # Delete Script & Package Folder
        Remove-Item -Path $MyInvocation.MyCommand.Source
        Remove-Item -Path $PackagePath -Force -Recurse

    }else{
        # script path
        $script_path = "$PackagePath\$PackageName.ps1"
        # get and save file content
        if(!$(Test-Path $PackagePath)){ New-Item -Path $PackagePath -Force -ItemType Directory }
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force
        
        # Register scheduled task to run at startup
        $schtaskDescription = "Version $Version"
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$script_path`""
        $settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
        Register-ScheduledTask -TaskName $PackageName -TaskPath Intune-Helper-Data -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force
    }
}catch{
    Write-Error $_
}

Stop-Transcript
