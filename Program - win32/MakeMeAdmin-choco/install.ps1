$ProgramName = "makemeadmin"

$Path_4Log = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$ProgramName-install.log" -Force

$localprograms = C:\ProgramData\chocolatey\choco.exe list --localonly
if ($localprograms -like "*$ProgramName*"){
    C:\ProgramData\chocolatey\choco.exe upgrade $ProgramName -y
}else{
    C:\ProgramData\chocolatey\choco.exe install $ProgramName -y
}

Stop-Transcript
