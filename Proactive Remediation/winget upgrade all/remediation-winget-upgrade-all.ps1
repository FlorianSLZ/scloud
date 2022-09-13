try{
    $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe")

    # upgrade command for ALL
    &$Winget upgrade --all #--query "" --silent --accept-package-agreements --accept-source-agreements

    exit 0

}catch{
    Write-Error "Error while installing upgarde for: $app_2upgrade"
    exit 1
}
