$PackageName = "PowerPoint-template"

$Path_4netIntune = "$env:LOCALAPPDATA\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Templates\blank.potx" -Force
Remove-Item -Path "$env:LOCALAPPDATA\4net\EndpointManager\Validation\$PackageName" -Force

Stop-Transcript