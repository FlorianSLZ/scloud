# Array of the PowerShell Modules
$PSModules = "ExchangeOnlineManagement", "MicrosoftTeams"

# ExecutionPolicy and NuGet
Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -Force

# Install all defined Modules
foreach($Module in $PSModules){
    Write-Host $Module
    Install-Module -Name $Module -Force
}