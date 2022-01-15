$PackageName = "chocolatey"
$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

try{
    New-Item -Path "C:\Admin\Intune" -ItemType Directory -Force
    if(!(test-path "C:\ProgramData\chocolatey\choco.exe")){
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }

    C:\ProgramData\chocolatey\choco.exe list -lo

    choco feature enable -n=useRememberedArgumentsForUpgrades
    
    exit 0
}catch{
    exit 1618
}


Stop-Transcript

