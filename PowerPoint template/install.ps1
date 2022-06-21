$PackageName = "PowerPoint-template"
$Version = "1"

$Path_4netIntune = "$env:LOCALAPPDATA\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force

try{
    # Create Templates folder
    New-Item -Path "$env:APPDATA\Microsoft\Templates" -ItemType "Directory" -Force
    # Copy template
    Copy-Item -Path "blank.potx" -Destination "$env:APPDATA\Microsoft\Templates\blank.potx" -Recurse -Force

    # Validation File
    New-Item -Path "$env:LOCALAPPDATA\4net\EndpointManager\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{$_}

Stop-Transcript
