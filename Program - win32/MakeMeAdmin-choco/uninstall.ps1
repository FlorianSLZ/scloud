$ProgramName = "makemeadmin"

$Path_4Log = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_4Log\Log\uninstall\$ProgramName-uninstall.log" -Force

C:\ProgramData\chocolatey\choco.exe uninstall $ProgramName -y

Stop-Transcript
