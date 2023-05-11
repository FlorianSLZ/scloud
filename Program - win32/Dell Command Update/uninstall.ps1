$PackageName = "Dell-Command-Update"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Start-Process "Dell-Command-Update-Application_30F6M_WIN_4.9.0_A01.EXE" -ArgumentList "/passthrough /x /s /v""/qn""" -Wait

Stop-Transcript