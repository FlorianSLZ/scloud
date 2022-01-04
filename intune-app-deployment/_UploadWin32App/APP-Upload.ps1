#$PSModules = "MSOnline","ExchangeOnlineManagement", "AzureADPreview", "Microsoft.Online.SharePoint.PowerShell", "MicrosoftTeams", "SharePointPnPPowerShellOnline", "MSCommerce"
# Array of the PowerShell Modules
$PSModules = "IntuneWin32App"

# ExecutionPolicy and NuGet
Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -Force

# Install all defined Modules
foreach($Module in $PSModules){
    Write-Host $Module
    Install-Module -Name $Module -Force
}