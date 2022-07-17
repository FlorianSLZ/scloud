$PackageName = "NormalEmail-template"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-uninstall.log" -Force

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

Remove-Item -Path "$Path_4Log\Validation\$PackageName" -Force

Stop-Transcript