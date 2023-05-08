$PackageName = "Normal-template"
$Version = "1"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

try{
    New-Item -Path "$env:APPDATA\Microsoft\Templates" -ItemType "Directory" -Force
    Copy-Item 'Normal.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force
    
    New-Item -Path "$ENV:LOCALAPPDATA\_MEM\$PackageName" -ItemType "file" -Force -Value $Version
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
