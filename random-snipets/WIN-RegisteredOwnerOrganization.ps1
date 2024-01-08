$PackageName = "WIN-RegisteredOwnerOrganization"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-script.log" -Force

# Base Path
$Path = "HKLM:\SOFTWARE\Microsoft\WindowsNT\CurrentVersion"


# Set RegisteredOwner
$Key = "RegisteredOwner"
$KeyFormat = "String"
$Value = "" # Username

if(!(Test-Path $Path)){New-Item -Path $Path -Force}
if(!$Key){Set-Item -Path $Path -Value $Value
}else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

# Set RegisteredOrganization
$Key = "RegisteredOrganization"
$KeyFormat = "String"
$Value = "scloud" # Company Name

if(!(Test-Path $Path)){New-Item -Path $Path -Force}
if(!$Key){Set-Item -Path $Path -Value $Value
}else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}



Stop-Transcript
