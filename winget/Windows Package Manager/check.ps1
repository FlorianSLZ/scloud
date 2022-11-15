$ProgramName = "Microsoft.DesktopAppInstaller"
$ProgramVersion_minimum = '2022.506.16.0'
$ProgramVersion_current = (Get-AppPackage -Name $ProgramName).Version

if($ProgramVersion_current -ge [System.Version]$ProgramVersion_minimum){
    Write-Host "Found it!"
}
