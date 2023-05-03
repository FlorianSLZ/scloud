$Path = "HKCU:\Software\Microsoft\Office\16.0\Outlook\Setup"
$Key = "DisableRoamingSignaturesTemporaryToggle" 
$KeyFormat = "dword"
$Value = "1"

if(!(Test-Path $Path)){New-Item -Path $Path -Force}
if(!$Key){Set-Item -Path $Path -Value $Value
}else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}
