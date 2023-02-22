$PackageName = "Excel-template"

$Path_local = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-uninstall.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Excel\XLSTART\Book.xltx" -Force
Remove-Item -Path "$env:APPDATA\Microsoft\Excel\XLSTART\Sheet.xltx" -Force
Remove-Item -Path "$Path_local\Validation\$PackageName" -Force

Stop-Transcript