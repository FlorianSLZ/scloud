$PackageName = "NormalEmail-template"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-$env:USERNAME-uninstall.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Templates\NormalEmail.dotm" -Force
Remove-Item -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName" -Force

Stop-Transcript