$PackageName = "Excel-template"
$Version = "1"

$Path_4netIntune = "$env:LOCALAPPDATA\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force

try{
    # Create Excel\XLSTART folder
    New-Item -Path "$env:APPDATA\Microsoft\Excel\XLSTART" -ItemType "Directory" -Force
    # Copy templates (Book & Sheet)
    Copy-Item -Path "Book.potx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Book.potx" -Recurse -Force
    Copy-Item -Path "Sheet.potx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Sheet.potx" -Recurse -Force

    # Validation File
    New-Item -Path "$env:LOCALAPPDATA\4net\EndpointManager\Validation\$PackageName" -ItemType "file" -Force -Value $Version
}catch{$_}

Stop-Transcript
