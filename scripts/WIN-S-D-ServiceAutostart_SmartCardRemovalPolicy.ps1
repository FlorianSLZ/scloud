$ScriptName = "WIN-S-D-ServiceAutostart_SmartCardRemovalPolicy"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$ScriptName.log" -Force

# Define service name
$ServiceName = "SCPolicySvc" # https://learn.microsoft.com/en-us/windows/security/identity-protection/smart-cards/smart-card-removal-policy-service

# Check if the service exists before modifying it
if (Get-Service -Name $ServiceName -ErrorAction SilentlyContinue) {
    try {
        Set-Service -Name $ServiceName -StartupType Automatic -ErrorAction Stop
        Write-Output "Successfully set $ServiceName to Automatic startup."

        # Start service if not running
        if ($Service.Status -ne 'Running') {
            Start-Service -Name $ServiceName -ErrorAction Stop
            Write-Output "Successfully started $ServiceName."
        } else {
            Write-Output "$ServiceName is already running."
        }

    } catch {
        Write-Error "Error while configuring $ServiceName : $_"
    }
} else {
    Write-Warning "Service $ServiceName not found."
}

Stop-Transcript
