$PackageName = "Dell-Command-Update"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-uninstall.log" -Force

Start-Process "Dell-Command-Update-Application_T97XP_WIN_4.6.0_A00.EXE" -ArgumentList "/passthrough /x /s /v""/qn""" -Wait

Stop-Transcript