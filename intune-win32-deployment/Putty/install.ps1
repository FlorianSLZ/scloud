$ProgramName = Get-Content choco.txt
$InstallParameter = Get-Content parameter.txt
$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$ProgramName-install.log" -Force

$localprograms = C:\ProgramData\chocolatey\choco.exe list --localonly
if ($localprograms -like "*$ProgramName*"){
    C:\ProgramData\chocolatey\choco.exe upgrade $ProgramName -y $InstallParameter
}else{
    C:\ProgramData\chocolatey\choco.exe install $ProgramName -y $InstallParameter
}

Stop-Transcript
