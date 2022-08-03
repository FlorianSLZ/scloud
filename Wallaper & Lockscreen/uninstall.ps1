$PackageName = "PROGRAMNAME"

Start-Transcript -Path "C:\Admin\Intune\Log\$PackageName-uninstall.log" -Force

Get-Package 'PROGRAM PACKAGE' | Uninstall-Package -Force
Return 1641

Remove-Item -Path "C:\Admin\Intune\Validation\$PackageName" -Force

Stop-Transcript