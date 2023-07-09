$PackageName = Get-Content choco.txt

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

$localprograms = C:\ProgramData\chocolatey\choco.exe list --localonly
if ($localprograms -like "*$PackageName*"){
    C:\ProgramData\chocolatey\choco.exe upgrade $PackageName -y
}else{
    C:\ProgramData\chocolatey\choco.exe install $PackageName -y
}

Stop-Transcript
