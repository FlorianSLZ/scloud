$PackageName = "LenovoSystemUpdate"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

try{
    Start-Process "system_update_5.07.0139.exe" -ArgumentList "/verysilent /norestart" -Wait
}catch{
    Write-Error $_
}

Stop-Transcript


https://thinkdeploy.blogspot.com/2020/10/autopilot-system-update-latest-drivers.html