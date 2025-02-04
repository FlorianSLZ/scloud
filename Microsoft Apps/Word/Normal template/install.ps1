$PackageName = "Normal-template"
$Version = "1"

$PackagePath = "$env:LOCALAPPDATA\Intune-Helper-Data\$PackageName"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

try{
    New-Item -Path "$env:APPDATA\Microsoft\Templates" -ItemType "Directory" -Force
    try{
        Write-Host "Try to replace Normal.dotm"
        Write-Host "$env:APPDATA\Microsoft\Templates\"
        Copy-Item 'Normal.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force

        # Check if Task exist with correct version
        $task_existing = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
        if($task_existing.Description -like "Version $Version*"){
            # Delete ScheduledTask
            Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

            # Delete Script & Package Folder
            Remove-Item -Path $MyInvocation.MyCommand.Source
            Remove-Item -Path $PackagePath -Force -Recurse

            }
        }
    catch{
        Write-Host "Replacement Failed: $_"

        Write-Host "Will create a task to replace the file at the next logon"

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

        exit 1618

    }

    Write-Host "Sucesfully updated the Normal.dotm. "
    # Detection Rule
    $Path = "HKLM:\SOFTWARE\scloud\Packages\$PackageName" 
    $Key = "Version" 
    $KeyFormat = "dword"
    $Value = $Version

    if(!(Test-Path $Path)){New-Item -Path $Path -Force}
    if(!$Key){Set-Item -Path $Path -Value $Value
    }else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}
    
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
