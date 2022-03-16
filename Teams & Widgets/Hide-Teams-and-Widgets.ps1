$Path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Key_Teams = "TaskbarMn"
$Key_Widgets = "TaskbarDn"
$KeyFormat = "DWord"
$Value = "0"

if(!(Test-Path $Path)){New-Item -Path $Path -Force}
Set-ItemProperty -Path $Path -Name $Key_Teams -Value $Value -Type $KeyFormat
Set-ItemProperty -Path $Path -Name $Key_Widgets -Value $Value -Type $KeyFormat