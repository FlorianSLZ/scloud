$PackageName = "PROGRAMNAME"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-uninstall.log" -Force

# Beispiel 
Get-Package 'PROGRAM PACKAGE' | Uninstall-Package -Force
Return 1641
######################################


Stop-Transcript