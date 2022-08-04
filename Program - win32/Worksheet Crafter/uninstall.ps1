$PackageName = "WorksheetCrafter"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-uninstall.log" -Force

Start-Process '"C:\Program Files (x86)\Worksheet Crafter\unins000.exe"' -ArgumentList '/SILENT /SUPPRESSMSGBOXES /LOG=c:\temp\uninstall.log' -Wait

Stop-Transcript