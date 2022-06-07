$PackageName = "NormalEmail-template"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-$env:USERNAME-uninstall.log" -Force

$NormalEmail_File = "$env:APPDATA\Microsoft\Templates\NormalEmail.dotm"

try{
    if(Test-Path $NormalEmail_File){Remove-Item -Path $NormalEmail_File -Force}
}catch{
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show('Your Outlook needs an Update with a restart. Please press OK to restart Outlook')
    Get-Process Outlook | Stop-Process -Force
    Start-Sleep 5
    if(Test-Path $NormalEmail_File){Remove-Item -Path $NormalEmail_File -Force}
    Start-Process Outlook
}

Remove-Item -Path "HKCU:\Software\Policies\Microsoft\Office\16.0\Common\MailSettings" -Force -Verbose

Remove-Item -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName" -Force

Stop-Transcript