# Self-elevate the script (admin rights)
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# download PSExec (PSTools)
$wc = New-Object System.Net.WebClient
$wc.Downloadfile("https://download.sysinternals.com/files/PSTools.zip", "$env:Temp\pstools.zip")
Expand-Archive -Path "$env:Temp\pstools.zip" -DestinationPath "$env:TEMP\pstools" -force

# accept Eula so you don't have to ;)
reg.exe ADD HKCU\Software\Sysinternals /v EulaAccepted /t REG_DWORD /d 1 /f | out-null

# Start PowerShell window as System
Start-Process -windowstyle hidden -FilePath "$env:TEMP\pstools\psexec.exe" -ArgumentList '-i -s powershell.exe'
