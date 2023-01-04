$PackageName = "FortiClientVPN"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

Get-Package 'FortiClient VPN' | Uninstall-Package -Force

Stop-Transcript