$PackageName = "FortiClientVPN"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-uninstall.log" -Force

Get-Package 'FortiClient VPN' | Uninstall-Package -Force

Stop-Transcript