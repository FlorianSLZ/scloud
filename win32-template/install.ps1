$PackageName = "PROGRAMNAME" # replace with your package name

$Path_local = "$Env:Programfiles\_MEM" # "$ENV:LOCALAPPDATA\_MEM" for user context installations
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force
$ErrorActionPreference = 'Stop'

try{
    Start-Process 'PROGRAMNAME.exe' -ArgumentList '/quiet' -Wait # this is a example, here comes your installation routine
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR while installing $PackageName"
    Write-Host "$_"
}

Stop-Transcript

