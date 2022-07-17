$PackageName = "PowerPoint-template"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-uninstall.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Templates\blank.potx" -Force
Remove-Item -Path "$Path_4Log\Validation\$PackageName" -Force

Stop-Transcript