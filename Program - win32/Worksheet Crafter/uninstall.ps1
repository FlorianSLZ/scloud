$PackageName = "WorksheetCrafter"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Start-Process '"C:\Program Files (x86)\Worksheet Crafter\unins000.exe"' -ArgumentList '/SILENT /SUPPRESSMSGBOXES /LOG=c:\temp\uninstall.log' -Wait

Stop-Transcript