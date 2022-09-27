$HPIA_folder = "C:\Program Files\HPImageAssistant"
$HPIA_report = "$HPIA_folder\Report"
$HPIA_exe = "$HPIA_folder\HPImageAssistant.exe"
$HPIA_category = "Drivers,Firmware"

try{
    Start-Process $HPIA_exe -ArgumentList "/Operation:Analyze /Action:Install /Category:$HPIA_category /Silent /AutoCleanup /reportFolder:""$HPIA_report""" -Wait 
    Write-Output "Installation completed"
}catch{
    Write-Error $_.Exception
}

