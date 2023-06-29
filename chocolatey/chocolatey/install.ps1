$PackageName = "chocolatey"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force


try{

    # Prüft choco Installation
    if($(Test-Path "C:\ProgramData\chocolatey\choco.exe")){
        # Upgrade chocolatey
        C:\ProgramData\chocolatey\choco.exe upgrade chocolatey
    }else{
        # Install chocolatey
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # Versions ANzeige für Log
    C:\ProgramData\chocolatey\choco.exe list -lo

    # Parameter merken für Updates von Paketen
    choco feature enable -n=useRememberedArgumentsForUpgrades
    
    exit 0
}catch{
    exit 1618
}


Stop-Transcript