$PackageName = "PowerPoint-template"
$Version = '1'

$Path_local = "$ENV:LOCALAPPDATA\_MEM"
$ProgramVersion_current = Get-Content -Path "$Path_local\Validation\$PackageName"

if($ProgramVersion_current -eq $Version){
    Write-Host "Found it!"
}