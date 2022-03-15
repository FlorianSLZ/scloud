$ProgramName = "FortiClientVPN"
$ProfileName = "DEMO scloud" # Change to your Profilename!
$ProgramVersion_target = '7.0.2.90' # Set to version from MSI
$ProgramPath = "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"
$ProgramVersion_current = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($ProgramPath).FileVersion
$RegPath = "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$ProfileName" 
$RegContent = Get-ItemProperty -Path $RegPath

if(($ProgramVersion_current -eq $ProgramVersion_target) -and ($RegContent)){
    Write-Host "Found it!"
}