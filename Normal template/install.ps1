$PackageName = "Normal-template"
$Version = "1"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-install.log" -Force

try{
    New-Item -Path "$env:APPDATA\Microsoft\Templates" -ItemType "Directory" -Force
    Copy-Item 'Normal.dotm' -Destination "$env:APPDATA\Microsoft\Templates\" -Recurse -Force
    New-Item -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR"
    Write-Host "$_"
    Write-Host "_____________________________________________________________________"
}

Stop-Transcript
