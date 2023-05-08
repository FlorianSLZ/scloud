$PackageName = "Normal-template"
$Version = '1'

$ProgramVersion_current = Get-Content -Path "$ENV:LOCALAPPDATA\_MEM\$PackageName"

if($ProgramVersion_current -eq $Version){
    Write-Host "Found it!"
}


