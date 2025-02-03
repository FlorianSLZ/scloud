$ScriptName = "WIN-S-D-ServiceAutostart_SmartCardRemovalPolicy"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$ScriptName.log" -Force

# Define service name
$ServiceName = "SCPolicySvc" # https://learn.microsoft.com/en-us/windows/security/identity-protection/smart-cards/smart-card-removal-policy-service

# Check if the service exists before modifying it
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    try {
        Set-Service -Name $ServiceName -StartupType Automatic -ErrorAction Stop
        Write-Output "Successfully set $ServiceName to Automatic startup."
    } catch {
        Write-Output "Failed to set $ServiceName to Automatic startup. Error: $_"
    }
} else {
    Write-Output "Service $ServiceName not found."
}

# Stop transcript
Stop-Transcript
