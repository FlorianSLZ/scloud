$PackageName = "PR4Business"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-uninstall.log" -Force

Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false

Stop-Transcript