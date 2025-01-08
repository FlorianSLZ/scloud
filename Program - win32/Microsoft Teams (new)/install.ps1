param (
    [string]$PackageName = "MicrosoftTeamsNEW",
    [string]$LogPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log"
)

# Start transcript logging
Start-Transcript -Path $LogPath -Force

###########################################################
# Remove classic Teams for all users
###########################################################
Write-Host "Remove classic Teams for all users"
Start-Process -FilePath ".\teamsbootstrapper.exe" -ArgumentList "-u" -NoNewWindow -Wait

###########################################################
# New Teams Installation
###########################################################
Write-Host "Installing new Teams"
Start-Process -FilePath ".\teamsbootstrapper.exe" -ArgumentList "-p" -NoNewWindow -Wait

# Stop transcript logging
Stop-Transcript
Write-Host "Script execution completed successfully."
