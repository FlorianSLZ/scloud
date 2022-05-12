$PackageName = "Firefox_WindowsCertificateStore"
$Path_Intune = "$Env:Programfiles\scloud\EndpointManager"
Start-Transcript -Path "$Path_Intune\Log\$PackageName-install.log" -Force

$localSettings_file = "C:\Program Files\Mozilla Firefox\defaults\pref\local-settings.js"
$profileCFG_file = "C:\Program Files\Mozilla Firefox\scloud.cfg"
$localSettings_content = ' pref("general.config.obscure_value", 0); 
 pref("general.config.filename", "scloud.cfg");'

$profileCFG_content = ' //
 lockPref("security.enterprise_roots.enabled", true);'

$localSettings_content | Out-File ( New-Item -Path $localSettings_file -Force) -Encoding Ascii
$profileCFG_content | Out-File ( New-Item -Path $profileCFG_file -Force) -Encoding Ascii


Stop-Transcript