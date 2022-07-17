$PackageName = "Excel-template"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-uninstall.log" -Force

Remove-Item -Path "Powerpoint_template.potx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Book.potx" -Force
Remove-Item -Path "Powerpoint_template.potx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Sheet.potx" -Force
Remove-Item -Path "$Path_4Log\Validation\$PackageName" -Force

Stop-Transcript