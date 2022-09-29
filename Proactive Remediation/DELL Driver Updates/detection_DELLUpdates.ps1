$DCU_folder = "C:\Program Files (x86)\Dell\CommandUpdate"
$DCU_reco = "$DCU_folder\Recommendations"
$DCU_exe = "$DCU_folder\dcu-cli.exe"
$DCU_category = "firmware, driver"  # bios,firmware,driver,application,others

Try {
    if([System.IO.File]::Exists($DCU_exe)){
        if(Test-Path $DCU_reco){Remove-Item $DCU_reco -Recurse -Force}
        $DCU_analyze = Start-Process $DCU_exe -ArgumentList "/scan -updateType=$DCU_category" -Wait
        
        if($DCU_analyze.count -lt 1){
            Write-Output "Compliant, no drivers needed"
            Exit 0
        }else{
            Write-Warning "Found drivers to download/install"
            Exit 1
        }
        
        
    }else{
        Write-Error "DELL Command Update missing"
        Exit 1
    }
} 
Catch {
    Write-Error $_.Exception
    Exit 1
}
