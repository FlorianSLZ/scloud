Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AllowDomainPINLogon" -Value 1 -Type DWORD

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PassportForWork" /v Enabled /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PassportForWork" /v DisablePostLogonProvisioning /t REG_DWORD /d 1 /f 
