$PackageName = "FortiClientVPN"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

Get-Package 'FortiClient VPN' | Uninstall-Package -Force

Stop-Transcript