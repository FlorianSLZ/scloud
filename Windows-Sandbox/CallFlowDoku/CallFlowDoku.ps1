# Array of the PowerShell Modules
$PSModules = "Microsoft.Graph", "MicrosoftTeams"

# ExecutionPolicy and NuGet
Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -Force

# Install all defined Modules
foreach($Module in $PSModules){
    Write-Host $Module
    Install-Module -Name $Module -Force
}




# Microsft 365 Documentation Creation
C:\Users\WDAGUtilityAccount\Desktop\CallFlowDoku\M365CallFlowVisualizerV2.ps1 

