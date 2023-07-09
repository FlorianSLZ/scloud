$PackageName = "DesktopIcon_SLZ"
$Version = "1"
$Path_local = "$Env:Programfiles\MEM"
$ProgramVersion_current = Get-Content -Path "$Path_local\Validation\$PackageName"

if($ProgramVersion_current -eq $Version){
    Write-Host "Found it!"
}