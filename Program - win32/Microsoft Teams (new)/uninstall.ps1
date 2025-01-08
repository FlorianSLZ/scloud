param (
    [string]$PackageName = "MicrosoftTeamsNEW",
    [string]$LogPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log"
)

# Start transcript logging
Start-Transcript -Path $LogPath -Force

###########################################################
# New Teams Uninstallation
###########################################################
Write-Host "Installing new Teams"
Start-Process -FilePath "teamsbootstrapper.exe" -ArgumentList "-x" -NoNewWindow -Wait

# Stop transcript logging
Stop-Transcript
Write-Host "Script execution completed successfully."
