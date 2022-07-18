$AllowedPath = ""           #   exp. C:\Windows\System32\cmd.exe;\\s-xx-app01\XYZ\;
$ServiceMode = ""           #   exp. C:\System\monitoring.exe;C:\Program Files\Agent\agentXY.exe;
$LogonFlag = "asadmin"      #   asservice or asadmin

$PolicyPath = "HKLM:\SOFTWARE\RunasRob"

if(!(Test-Path $PolicyPath)){New-Item -Path $PolicyPath -Force}
if($AllowedPath){Set-ItemProperty -Path $PolicyPath -Name "AllowedPath" -Value $AllowedPath -Type "ExpandString"}
if($ServiceMode){Set-ItemProperty -Path $PolicyPath -Name "ServiceMode" -Value $ServiceMode -Type "ExpandString"}
if($LogonFlag){Set-ItemProperty -Path $PolicyPath -Name "LogonFlag" -Value $LogonFlag -Type "ExpandString"}
