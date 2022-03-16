$Path = "HKLM:\\SOFTWARE\Policies\Microsoft\Dsh"
$Key = "AllowNewsAndInterests"
$KeyFormat = "DWord"
$Value = "0"

if(!(Test-Path $Path)){New-Item -Path $Path -Force}
Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat
