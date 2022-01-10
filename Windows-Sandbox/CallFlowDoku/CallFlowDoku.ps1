# Array of the PowerShell Modules
$PSModules = "MSOnline", "MicrosoftTeams"

# ExecutionPolicy and NuGet
Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -Force

# Install all defined Modules
foreach($Module in $PSModules){
    Write-Host $Module
    Install-Module -Name $Module -Force
}




# Microsft 365 Documentation Creation
Unblock-File C:\Users\WDAGUtilityAccount\Desktop\CallFlowDoku\M365CallFlowVisualizerV2.ps1
C:\Users\WDAGUtilityAccount\Desktop\CallFlowDoku\M365CallFlowVisualizerV2.ps1 -ExecutionPolicy bypass

