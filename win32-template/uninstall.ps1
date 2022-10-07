$PackageName = "PROGRAMNAME"

$Path_local = "$Env:Programfiles\_MEM" # "$ENV:LOCALAPPDATA\_MEM" for user context installations
Start-Transcript -Path "$Path_local\Log\uninstall\$PackageName-install.log" -Force

try{
    Start-Process 'PROGRAMNAME.exe' -ArgumentList '/uninstall' -Wait # this is a example, here comes your uninstallation routine
}catch{
    Write-Host "_____________________________________________________________________"
    Write-Host "ERROR while uninstalling $PackageName"
    Write-Host "$_"
}

Stop-Transcript

