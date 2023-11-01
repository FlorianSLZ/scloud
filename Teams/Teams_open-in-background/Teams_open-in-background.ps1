$PackageName = "Teams_open-in-background"
$Version = "1"

$Path_local = "$env:LOCALAPPDATA\MEM"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

try{
    # registry key
    $KeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    
    # Check if Property exist with correct version
    $PropertyName = "$PackageName - V$Version"
    $Property_existing = Get-ItemProperty $KeyPath -Name $PropertyName -ErrorAction SilentlyContinue
    if($Property_existing){

        try{
            ############################################################################################
            #   CODE TO RUN ONCE

            # End acitve Teams process
            if(Get-Process ms-teams -ErrorAction SilentlyContinue){Get-Process ms-teams | Stop-Process -Force}
            # Replace/Set "open_app_in_background" option to true
            $SettingsJSON = "$ENV:LocalAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\app_settings.json"
            (Get-Content $SettingsJSON -ErrorAction Stop).replace('"open_app_in_background":false', '"open_app_in_background":true') | Set-Content $SettingsJSON -Force

            #   END CODE TO RUN ONCE
            ############################################################################################

        # Delete Script
        Remove-Item -Path $MyInvocation.MyCommand.Source 
        }catch{$_}

    }else{
        # script path
        $script_path = "$Path_local\Data\$PackageName.ps1"
        New-Item -ItemType Directory -Force -Path "$Path_local\Data" | Out-Null
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force

        # Create Property with script to execute
        Set-ItemProperty $KeyPath -Name $PropertyName -Value "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File `"$script_path`""
    }
}catch{
    Write-Error $_
}

Stop-Transcript

