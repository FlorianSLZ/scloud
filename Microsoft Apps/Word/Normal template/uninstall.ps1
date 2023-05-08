$PackageName = "Normal-template"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Templates\Normal.dotm" -Force
Remove-Item -Path "$ENV:LOCALAPPDATA\_MEM\$PackageName" -Force

Stop-Transcript