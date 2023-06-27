$PackageName = "makemeadmin"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

C:\ProgramData\chocolatey\choco.exe uninstall $PackageName -y

Stop-Transcript
