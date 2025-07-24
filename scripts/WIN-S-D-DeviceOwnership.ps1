$ScriptName = "WIN-S-D-DeviceOwnership"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$ScriptName.log" -Force

$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$Key = "RegisteredOwner"
$KeyFormat = "string"
$Value = "scloud.work"

if (!(Test-Path $Path)) {New-Item -Path $Path -Force}
if (!$Key) {Set-Item -Path $Path -Value $Value}
else {Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

$Path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$Key = "RegisteredOrganization"
$KeyFormat = "string"
$Value = "scloud"

if (!(Test-Path $Path)) {New-Item -Path $Path -Force}
if (!$Key) {Set-Item -Path $Path -Value $Value}
else {Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

Stop-Transcript
