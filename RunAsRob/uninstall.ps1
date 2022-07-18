$PackageName = "RunAsRob"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-uninstall.log" -Force

Start-Process 'RunAsRob.exe' -ArgumentList '/uninstall /quiet' -Wait

Stop-Transcript