$PackageName = "Normal-template"
$ProgramVersion_target = '1'
$ProgramVersion_current = Get-Content -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName"

if($ProgramVersion_current -eq $ProgramVersion_target){
    Write-Host "Found it!"
}