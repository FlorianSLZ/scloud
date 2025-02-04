$ScriptName = "WIN-S-D-ServiceAutostart_SmartCardRemovalPolicy"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$ScriptName.log" -ForceStop-Transcript

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork"
$Key = "Enabled"
$KeyFormat = "dword"
$Value = "1"

if (!(Test-Path $Path)) {New-Item -Path $Path -Force}
if (!$Key) {Set-Item -Path $Path -Value $Value}
else {Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork"
$Key = "DisablePostLogonProvisioning"
$KeyFormat = "dword"
$Value = "1"

if (!(Test-Path $Path)) {New-Item -Path $Path -Force}
if (!$Key) {Set-Item -Path $Path -Value $Value}
else {Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

Stop-Transcript
