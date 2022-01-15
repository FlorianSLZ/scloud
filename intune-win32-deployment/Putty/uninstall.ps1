$ProgramName = Get-Content choco.txt
$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-uninstall.log" -Force

C:\ProgramData\chocolatey\choco.exe uninstall $ProgramName -y

Stop-Transcript
