$PackageName = "Dell-Command-Update"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Start-Process "Dell-Command-Update-Application_4R78G_WIN_5.2.0_A00.EXE" -ArgumentList "/passthrough /x /s /v""/qn""" -Wait

Stop-Transcript
