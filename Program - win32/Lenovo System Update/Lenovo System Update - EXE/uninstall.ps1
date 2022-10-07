$PackageName = "LenovoSystemUpdate"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-uninstall.log" -Force

Start-Process "C:\Program Files (x86)\Lenovo\System Update\unins000.exe" -ArgumentList "/VERYSILENT /NORESTART" -Wait

Stop-Transcript
