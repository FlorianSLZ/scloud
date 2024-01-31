$LSU_exe = "C:\Program Files (x86)\Lenovo\System Update\tvsuShim.exe"
$LSU_command = "/CM -search R -action LIST -includerebootpackages 3"
$LSU_Logs = "C:\ProgramData\Lenovo\SystemUpdate\logs"

Try {
    if([System.IO.File]::Exists($LSU_exe)){

        Start-Process $LSU_exe -ArgumentList $LSU_command -Wait

        

        $HPIA_analyze = Get-Content "$HPIA_reco\*.json" | ConvertFrom-Json

        if($HPIA_analyze.HPIA.Recommendations.count -lt 1){
            Write-Output "Compliant, no drivers needed"
            Exit 0
        }else{
            Write-Warning "Found drivers to download/install: $($HPIA_analyze.HPIA.Recommendations)"
            Exit 1
        }
        
        
    }else{
        Write-Error "Lenovo System Update is missing"
        Exit 1
    }
} 
Catch {
    Write-Error $_.Exception
    Exit 1
}

