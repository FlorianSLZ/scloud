$PackageName = "HPImageAssistant"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-uninstall.log" -Force

Remove-Item -Path "$Env:Programfiles\HPImageAssistant" -Recurse -Force

Stop-Transcript