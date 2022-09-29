$DCU_folder = "C:\Program Files (x86)\Dell\CommandUpdate"
$DCU_reco = "$DCU_folder\Recommendations"
$DCU_exe = "$DCU_folder\dcu-cli.exe"
$DCU_category = "firmware, driver"  # bios,firmware,driver,application,others

try{
    Start-Process $DCU_exe -ArgumentList "/applyUpdates -silent -reboot=disable -updateType=$DCU_category -outputlog=""$Env:Programfiles\_MEM\Log\Dell_update.log""" -Wait
    Write-Output "Installation completed"
}catch{
    Write-Error $_.Exception
}

