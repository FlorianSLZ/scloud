$PackageName = "NormalEmail-template"
$Version = 1

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
$ProgramVersion_current = Get-Content -Path "$Path_4Log\Validation\$PackageName"

if($ProgramVersion_current -eq $Version){
    Write-Host "Found it!"
}


