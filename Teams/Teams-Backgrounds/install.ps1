$PackageName = "Teams-new-Backgrounds"
$Version = "1"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-$env:USERNAME-install.log" -Force

try{
    # Local Folder 
    $TeamsBG_Folder = "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads"

    # Reference IDs
    $TeamsBG_ref = "$TeamsBG_Folder\TeamsBackgrounds.csv"
    
    # Create folder if not exists
    if(!$(Test-Path $TeamsBG_Folder)){New-Item -ItemType directory -Path $TeamsBG_Folder -Force}

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
    
    # Copy Backgrounds and rename with GUID
    $vBackgrounds = Get-ChildItem -Path '.\bg' 
    $vBackgrounds_GUID = @()
    foreach($vBackground in $vBackgrounds){
        $vBackground_guid = [guid]::NewGuid().GUID
        Write-Host "Saving $($vBackground.Name) as $vBackground_guid ..."
        Copy-Item -Path $vBackground.FullName -Destination "$TeamsBG_Folder\$vBackground_guid$($vBackground.Extension)" -Force
        Copy-Item -Path $vBackground.FullName -Destination $("$TeamsBG_Folder\$vBackground_guid" + "_thumb" + "$($vBackground.Extension)") -Force

        $vBackgrounds_GUID += $vBackground_guid

    }

    $vBackgrounds_GUID | Out-File $TeamsBG_ref -Force
    $obj_list = $vBackgrounds_GUID | Select-Object @{Name='Name';Expression={$_}}
    $obj_list | Export-Csv $TeamsBG_ref -NoTypeInformation 

    # Detection Key
    $Path = "HKCU:\SOFTWARE\scloud\$PackageName" 
    $Key = "Version" 
    $KeyFormat = "string"
    $Value = $Version

    if(!(Test-Path $Path)){New-Item -Path $Path -Force}
    if(!$Key){Set-Item -Path $Path -Value $Value
    }else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}


    
}catch{
    Write-Error "$_"
}

Stop-Transcript
