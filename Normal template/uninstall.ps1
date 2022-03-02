$PackageName = "Normal-template"

Start-Transcript -Path "C:\Admin\Intune\Log\$PackageName-$env:USERNAME-uninstall.log" -Force

Remove-Item -Path "$env:APPDATA\Microsoft\Templates\Normal.dotm" -Force
Remove-Item -Path "$env:localAPPDATA\Intune\Validation\$PackageName" -Force

Stop-Transcript