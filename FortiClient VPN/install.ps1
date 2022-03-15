# Akteulle EXE: 
# Für MSI EXE ausführen und downlaod abwarten, dann unter %temp%\{GUID} die MSI kopieren

$PackageName = "FortiClientVPN"
$ConfigPW = "Kateoih785"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

(Start-Process "msiexec.exe" -ArgumentList "/i FortiClientVPN.msi /passive /quiet INSTALLLEVEL=3 DESKTOPSHORTCUT=0 /NORESTART" -NoNewWindow -Wait -PassThru).ExitCode
Start-Process "C:\Program Files\Fortinet\FortiClient\FCConfig.exe" -ArgumentList "-m vpn -f FortiClientVPN.conf -o import -p $ConfigPW" -Wait

Stop-Transcript
