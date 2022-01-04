$PackageName = "DesktopIcon_SLZ"
$Version = "1"
$ProgramVersion_current = Get-Content -Path "$Env:Programfiles\4net\EndpointManager\Validation\$PackageName"

if($ProgramVersion_current -eq $Version){
    Write-Host "Found it!"
}