# Array of the PowerShell Modules
$PSModules = "MSAL.PS", "PSWriteWord", "M365Documentation"

# ExecutionPolicy and NuGet
Set-ExecutionPolicy Unrestricted -Force
Install-PackageProvider -Name NuGet -Force

# Install all defined Modules
foreach($Module in $PSModules){
    Write-Host $Module
    Install-Module -Name $Module -Force
}




# Microsft 365 Documentation Creation
## Connect to tenant
Connect-M365Doc

## Collect information for component Intune as an example 
$doc = Get-M365Doc -Components Intune, AzureAD -ExcludeSections @("MobileAppDetailed", "AADBranding", "AADDirectoryRole", "AADIdentityProvider", "AADOrganization", "AADPolicy")

## Output the documentation to a Word file
$doc | Write-M365DocWord -FullDocumentationPath "c:\$($doc.Organization)_$($doc.CreationDate.ToString("yyyy-MM-dd"))_M365-Doc.docx"
