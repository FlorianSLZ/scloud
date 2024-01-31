# The variable $CloudUser requires UPN of a Global Administrator user (username@companyname.com).
# The variable $Onpremuser requires a Down-Level Logon Name (DOMAIN\USERNAME). The user can be a domain administrator or a hybrid identity administrator.

$CloudUser = 'username@companyname.com'
$CloudEncrypted = Get-Content "C:\Scripts\azureAd_Encrypted_Password.txt" | ConvertTo-SecureString
$CloudCred = New-Object System.Management.Automation.PsCredential($CloudUser,$CloudEncrypted)
$OnpremUser = 'DOMAIN\USERNAME'
$OnpremEncrypted = Get-Content "C:\Scripts\onPrem_Encrypted_Password.txt" | ConvertTo-SecureString
$OnpremCred = New-Object System.Management.Automation.PsCredential($OnpremUser,$OnpremEncrypted)
 
Import-Module 'C:\Program Files\Microsoft Azure Active Directory Connect\AzureADSSO.psd1'
New-AzureADSSOAuthenticationContext -CloudCredentials $CloudCred
Update-AzureADSSOForest -OnPremCredentials $OnpremCred
