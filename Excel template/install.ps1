$PackageName = "Excel-template"
$Version = "1"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-install.log" -Force

try{
    # Create Excel\XLSTART folder
    New-Item -Path "$env:APPDATA\Microsoft\Excel\XLSTART" -ItemType "Directory" -Force
    # Copy templates (Book & Sheet)
    Copy-Item -Path "Book.xltx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Book.xltx" -Recurse -Force
    Copy-Item -Path "Sheet.xltx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Sheet.xltx" -Recurse -Force

    # Validation File
    New-Item -Path "$Path_4Log\Validation\$PackageName" -ItemType "file" -Force -Value $Version

}catch{$_}

Stop-Transcript
