$PackageName = "PowerPoint-template"

$Path_local = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-uninstall.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Templates\blank.potx" -Force
Remove-Item -Path "$Path_local\Validation\$PackageName" -Force

Stop-Transcript