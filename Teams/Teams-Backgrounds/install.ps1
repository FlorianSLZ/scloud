$PackageName = "Teams-Backgrounds"
$Version = "1"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-$env:USERNAME-install.log" -Force
$ErrorActionPreference = "Stop"

try{
    # Local Folder 
    $TeamsBG_Folder = "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads"
    
    # Sicherstelen, das der Ordner vorhanden ist
    New-Item -ItemType directory -Path $TeamsBG_Folder -Force
    
    # Hintergründe kopieren
    $vBackgrounds = Get-ChildItem -Path '.\bg' 
    foreach($vBackground in $vBackgrounds){
        $vBackground_guid = [guid]::NewGuid().Guid
        Copy-Item -path $vBackground.FullName -Destination "$TeamsBG_Folder\$vBackground_guid$($vBackground.Extension)" -Force -WhatIf

    }

    # Validation Key
    New-Item "HKCU:\SOFTWARE\scloud\Packages\$PackageName" -Force | New-ItemProperty -Name Version -Value $Version -Force


    
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
