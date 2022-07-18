$PackageName = "RunAsRob"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-install.log" -Force

try{
    Start-Process 'RunAsRob.exe' -ArgumentList '/install /quiet' -Wait
    .\RunAsRob_Policies.ps1
}catch{
    Write-Error $_
}

Stop-Transcript