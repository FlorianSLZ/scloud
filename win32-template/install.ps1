$PackageName = "PROMGRAMMANME"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

# Beispiel 
Start-Process 'PROGRAMNAME.exe' -ArgumentList '/quiet' -Wait
######################################

Stop-Transcript



