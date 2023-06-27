$PackageName = "makemeadmin"
$InstallParameter = Get-Content parameter.txt -ErrorAction SilentlyContinue

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

$localprograms = C:\ProgramData\chocolatey\choco.exe list
if ($localprograms -like "*$PackageName*"){
    C:\ProgramData\chocolatey\choco.exe upgrade $PackageName -y $InstallParameter
}else{
    C:\ProgramData\chocolatey\choco.exe install $PackageName -y $InstallParameter
}

Stop-Transcript
