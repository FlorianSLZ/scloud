$PackageName = "MicrosoftTeamsNEW"
$LogPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log"

# Start transcript logging
Start-Transcript -Path $LogPath -Force

Write-Host "Uninstalling new Teams"
& '.\teamsbootstrapper.exe' -x

Stop-Transcript
