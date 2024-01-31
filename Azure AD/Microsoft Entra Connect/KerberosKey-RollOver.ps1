$onPrem_DomainAdmin = Get-Credential -Message "Enter the credentials of an on-premises domain administrator (DOMAIN\USERNAME)"
 
Import-Module 'C:\Program Files\Microsoft Azure Active Directory Connect\AzureADSSO.psd1'
New-AzureADSSOAuthenticationContext 
Update-AzureADSSOForest -OnPremCredentials $onPrem_DomainAdmin
