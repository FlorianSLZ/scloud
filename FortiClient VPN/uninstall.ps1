$PackageName = "FortiClientVPN"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-uninstall.log" -Force

Get-Package 'FortiClient VPN' | Uninstall-Package -Force

Stop-Transcript