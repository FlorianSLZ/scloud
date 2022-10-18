$ProgramName = "makemeadmin"

$Path_local = "$Env:Programfiles\_MEM" 
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force
$ErrorActionPreference = 'Stop'

try{
    Start-Process 'MakeMeAdmin 2.3.0 x64.msi' -ArgumentList '/quiet' -Wait
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR while installing $PackageName"
    Write-Host "$_"
}

Stop-Transcript