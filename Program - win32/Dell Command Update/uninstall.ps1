$PackageName = "Dell-Command-Update"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Start-Process "Dell-Command-Update-Application_714J9_WIN_4.8.0_A00.EXE" -ArgumentList "/passthrough /x /s /v""/qn""" -Wait

Stop-Transcript