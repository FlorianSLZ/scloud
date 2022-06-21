$PackageName = "Excel-template"

$Path_4netIntune = "$env:LOCALAPPDATA\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force

Remove-Item -Path "Powerpoint_template.potx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Book.potx" -Force
Remove-Item -Path "Powerpoint_template.potx" -Destination "$env:APPDATA\Microsoft\Excel\XLSTART\Sheet.potx" -Force
Remove-Item -Path "$env:LOCALAPPDATA\4net\EndpointManager\Validation\$PackageName" -Force

Stop-Transcript