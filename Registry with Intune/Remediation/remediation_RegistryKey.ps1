$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Key = "HiberbootEnabled" 
$KeyFormat = "DWORD"
$Value = 0

try{
    if(!(Test-Path $Path)){New-Item -Path $Path -Force}
    if(!$Key){Set-Item -Path $Path -Value $Value}
    else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}
    Write-Output "Key set: $Key = $Value"
}catch{
    Write-Error $_
}