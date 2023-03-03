$PackageName = "Excel-template"
$Version = "1"

$Path_local = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

try{
    # Create Excel\XLSTART folder
    New-Item -Path "$env:APPDATA\Microsoft\Excel\XLSTART" -ItemType "Directory" -Force
    # Copy templates (Book & Sheet)
    Copy-Item -Path "Book.xltx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Book.xltx" -Recurse -Force
    Copy-Item -Path "Sheet.xltx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Sheet.xltx" -Recurse -Force

    # Default Font
    $Path = "HKCU:\Software\Microsoft\Office\16.0\Excel\Options" 
    $Key = "Font" 
    $KeyFormat = "String"
    $Value = "Arial,10"
    if(!(Test-Path $Path)){New-Item -Path $Path -Force}
    if(!$Key){Set-Item -Path $Path -Value $Value
    }else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

    # Validation File
    New-Item -Path "$Path_local\Validation\$PackageName" -ItemType "file" -Force -Value $Version

}catch{$_}

Stop-Transcript
