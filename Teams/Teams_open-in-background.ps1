$PackageName = "Teams_open-in-background"
$Version = "1"

$Path_4netIntune = "$env:LOCALAPPDATA\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force
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
            if(Get-Process Teams -ErrorAction SilentlyContinue){Get-Process Teams | Stop-Process -Force}
            # Replace/Set "openAsHidden" option to true
            (Get-Content $ENV:APPDATA\Microsoft\Teams\desktop-config.json -ErrorAction Stop).replace('"openAsHidden":false', '"openAsHidden":true') | Set-Content $ENV:APPDATA\Microsoft\Teams\desktop-config.json
            # Start Teams in background
            Start-Process -File $env:LOCALAPPDATA\Microsoft\Teams\Update.exe -ArgumentList '--processStart "Teams.exe" --process-start-args "--system-initiated"'

            #   END CODE TO RUN ONCE
            ############################################################################################

        # Delete Script
        Remove-Item -Path $MyInvocation.MyCommand.Source 
        }catch{$_}

    }else{
        # script path
        $script_path = "$Path_4netIntune\Data\$PackageName.ps1"
        # get and save file content
        Get-Content -Path $($PSCommandPath) | Out-File -FilePath $script_path -Force

        # Create Property with script to execute
        Set-ItemProperty $KeyPath -Name $PropertyName -Value "C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File `"$script_path`""
    }
}catch{
    Write-Error $_
}

Stop-Transcript




















