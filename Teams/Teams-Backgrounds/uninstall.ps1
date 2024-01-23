$PackageName = "Teams-new-Backgrounds"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-$env:USERNAME-install.log" -Force

try{
    # Local Folder 
    $TeamsBG_Folder = "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads"

    # Reference IDs
    $TeamsBG_ref = "$TeamsBG_Folder\TeamsBackgrounds.csv"

    if(Test-Path $TeamsBG_ref){
        # Clean up old files
        $TeamsBG_old = Import-Csv -Path $TeamsBG_ref
        foreach($TeamsBG in $TeamsBG_old.Name){
            Write-Host "Removing $TeamsBG ..."
            Remove-Item -Path "$TeamsBG_Folder\$TeamsBG*" -Force
        }
    }else{
        Write-Host "No old files found"
    }
    

    # Validation Key
    Remove-Item -Path "$TeamsBG_Folder\$PackageName" -Force


    
}catch{
    Write-Error "$_"
}

Stop-Transcript
