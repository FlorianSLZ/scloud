# Module by https://github.com/jseerden/IntuneBackupAndRestore
# Install-Module -Name IntuneBackupAndRestore -Scope CurrentUser
Install-Module -Name Microsoft.Graph.Intune -Scope CurrentUser


$BackupPath = Read-Host "Backup path"

$session = Connect-MSGraph
#Import-Module IntuneBackupAndRestore



# COnfigruation
$WIN_WH4BactivationJSON = {
    "@odata.type":  "#microsoft.graph.windowsIdentityProtectionConfiguration",
    "roleScopeTagIds":  [
                            "0"
                        ],
    "supportsScopeTags":  true,
    "deviceManagementApplicabilityRuleOsEdition":  null,
    "deviceManagementApplicabilityRuleOsVersion":  null,
    "deviceManagementApplicabilityRuleDeviceMode":  null,
    "description":  "Windows Hello for Business, Hybrid Cloud Trust configuration",
    "displayName":  "WIN WH4B activation",
    "useSecurityKeyForSignin":  false,
    "enhancedAntiSpoofingForFacialFeaturesEnabled":  true,
    "pinMinimumLength":  6,
    "pinMaximumLength":  null,
    "pinUppercaseCharactersUsage":  "notConfigured",
    "pinLowercaseCharactersUsage":  "notConfigured",
    "pinSpecialCharactersUsage":  "notConfigured",
    "pinExpirationInDays":  null,
    "pinPreviousBlockCount":  null,
    "pinRecoveryEnabled":  false,
    "securityDeviceRequired":  true,
    "unlockWithBiometricsEnabled":  true,
    "useCertificatesForOnPremisesAuthEnabled":  false,
    "windowsHelloForBusinessBlocked":  false,
    "deviceConfigurationId":  "86c6218c-7b47-4853-bda9-f34330baa38a",
    "deviceConfigurationODataType":  "microsoft.graph.windowsIdentityProtectionConfiguration",
    "windowsIdentityProtectionConfigurationReferenceUrl":  "https://graph.microsoft.com/Beta/deviceManagement/deviceConfigurations/86c6218c-7b47-4853-bda9-f34330baa38a"
}


$WIN_WH4BcloudtrustJSON = {
    "@odata.type":  "#microsoft.graph.windows10CustomConfiguration",
    "roleScopeTagIds":  [
                            "0"
                        ],
    "supportsScopeTags":  true,
    "deviceManagementApplicabilityRuleOsEdition":  null,
    "deviceManagementApplicabilityRuleOsVersion":  null,
    "deviceManagementApplicabilityRuleDeviceMode":  null,
    "description":  "OMA URI for Windows Hello for Business cloud trust",
    "displayName":  "WIN WH4B cloud trust",
    "omaSettings":  [
                        {
                            "@odata.type":  "#microsoft.graph.omaSettingBoolean",
                            "displayName":  "UseCloudTrustForOnPremAuth",
                            "description":  "Windows Hello for Business cloud trust",
                            "omaUri":  "./Device/Vendor/MSFT/PassportForWork/$($session.TenantId)/Policies/UseCloudTrustForOnPremAuth",
                            "secretReferenceValueId":  null,
                            "isEncrypted":  false,
                            "value":  true
                        }
                    ],
    "deviceConfigurationId":  "0fbfd0cd-f7c2-46c0-aeaa-f0febef9bd88",
    "deviceConfigurationODataType":  "microsoft.graph.windows10CustomConfiguration",
    "windows10CustomConfigurationReferenceUrl":  "https://graph.microsoft.com/Beta/deviceManagement/deviceConfigurations/0fbfd0cd-f7c2-46c0-aeaa-f0febef9bd88"
}






#Invoke-IntuneRestoreDeviceConfiguration -Path $BackupPath


# To backup your own: Invoke-IntuneBackupDeviceConfiguration -Path $BackupPath

$deviceConfigurationDisplayName = ($deviceConfigurationContent | ConvertFrom-Json).displayName
$requestBodyObject = $deviceConfigurationContent | ConvertFrom-Json
$requestBody = $requestBodyObject | Select-Object -Property * -ExcludeProperty id, createdDateTime, lastModifiedDateTime, version | ConvertTo-Json -Depth 100


try {
    $null = Invoke-MSGraphRequest -HttpMethod POST -Content $requestBody.toString() -Url "deviceManagement/deviceConfigurations" -ErrorAction Stop
    [PSCustomObject]@{
        "Action" = "Restore"
        "Type"   = "Device Configuration"
        "Name"   = $deviceConfigurationDisplayName
        "Path"   = "Device Configurations\$($deviceConfiguration.Name)"
    }
}
catch {
    Write-Verbose "$deviceConfigurationDisplayName - Failed to restore Device Configuration" -Verbose
    Write-Error $_ -ErrorAction Continue
}