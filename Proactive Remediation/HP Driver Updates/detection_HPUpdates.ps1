$HPIA_folder = "C:\Program Files\HPImageAssistant"
$HPIA_reco = "$HPIA_folder\Recommendations"
$HPIA_exe = "$HPIA_folder\HPImageAssistant.exe"
$HPIA_category = "Drivers,Firmware" 

Try {
    if([System.IO.File]::Exists($HPIA_exe)){
        if(Test-Path $HPIA_reco){Remove-Item $HPIA_reco -Recurse -Force}
        Start-Process $HPIA_exe -ArgumentList "/Operation:Analyze /Category:$HPIA_category /Action:List /Silent /ReportFolder:""$HPIA_reco""" -Wait
        $HPIA_analyze = Get-Content "$HPIA_reco\*.json" | ConvertFrom-Json

        if($HPIA_analyze.HPIA.Recommendations.count -lt 1){
            Write-Output "Compliant, no drivers needed"
            Exit 0
        }else{
            Write-Warning "Found drivers to download/install"
            Exit 1
        }
        
        
    }else{
        Write-Error "HP Image Assistant missing"
        Exit 1
    }
} 
Catch {
    Write-Error $_.Exception
    Exit 1
}

