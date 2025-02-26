<#PSScriptInfo

.VERSION 1.0
.GUID b00d1997-e5da-4af1-86f0-92120c168436
.AUTHOR Florian Salzmann
.COMPANYNAME scloud.work
.COPYRIGHT 2025 Florian Salzmann. GPL-3.0 license.
.TAGS PowerShell Groupmanagement Intune MicrosoftGraph Entra EntraID
.LICENSEURI https://github.com/FlorianSLZ/scloud/blob/main/LICENSE
.PROJECTURI https://github.com/FlorianSLZ/scloud/tree/main/scripts/Set-GroupByPrimaryUser
.ICONURI https://scloud.work/wp-content/uploads/Set-GroupByPrimaryUser.webp 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
    2025-02-26, 1.0:    Original published version.

#> 

<# 

.DESCRIPTION 
Synchronizes devices in the target device group based on the primary users in the source user group.
- Adds missing devices.
- Removes devices that no longer belong.
- Updates the group description with the device count.
- Allows filtering by OS type and ownership.

#> 

param (
    [parameter(Mandatory = $true, HelpMessage = "Group ID of the user group")]
    [string]$UserGroupObjectID,

    [parameter(Mandatory = $true, HelpMessage = "Group ID of the device group")]
    [string]$DeviceGroupObjectID,

    [parameter(Mandatory = $false, HelpMessage = "Filter by OS type (e.g., Windows, iOS, Android or MacMDM)")]
    [ValidateSet("Windows", "MacMDM", "iOS", "Android", "Linux")]
    [string[]]$OSFilter,

    [parameter(Mandatory = $false, HelpMessage = "Filter by device ownership (Company or Personal)")]
    [ValidateSet("Company", "Personal")]
    [string]$OwnershipFilter,

    [parameter(Mandatory = $false, HelpMessage = "If set, no devices will be removed from the group")]
    [ValidateSet("Company", "Personal")]
    [switch]$noRemove
)

# Ensure Microsoft.Graph modules are installed and imported
$requiredModules = @("Microsoft.Graph.Users", "Microsoft.Graph.Groups", "Microsoft.Graph.DeviceManagement")
foreach ($module in $requiredModules) {
    if (!(Get-Module -Name $module -ListAvailable)) {
        Install-Module $module -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module $module
}

# Authenticate with Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All", "User.Read.All", "Device.Read.All", "GroupMember.ReadWrite.All"

# Get all users (including nested) from the source group
$allUsers = Get-MgGroupTransitiveMember -GroupId $UserGroupObjectID -All 

$allDevices = @()
foreach ($user in $allUsers) {
    # Get devices where the user is the primary user
    $devices = Get-MgUserOwnedDevice -UserId $user.Id -All

    foreach ($device in $devices) {
        # Fetch detailed device information
        $deviceDetails = Get-MgDevice -DeviceId $device.Id

        # Apply OS filter
        if ($OsFilter -and $deviceDetails.OperatingSystem -notin $OsFilter) {
            Write-Host "Skipping device $($device.Id) due to OS filter: $($deviceDetails.OperatingSystem)" -ForegroundColor Gray
            continue
        }

        # Apply ownership filter
        if ($OwnershipFilter -and $deviceDetails.DeviceOwnership -ne $OwnershipFilter) {
            Write-Host "Skipping device $($device.Id) due to ownership filter: $($deviceDetails.DeviceOwnership)" -ForegroundColor Gray
            continue
        }

        # Add to the list of valid devices
        $allDevices += $device.Id
    }
}

$allDevices = $allDevices | Select-Object -Unique

# Get existing devices in the target group
$existingDevices = Get-MgGroupMember -GroupId $DeviceGroupObjectID -All | Select-Object -ExpandProperty Id

# Add new devices
foreach ($deviceId in $allDevices) {
    if ($existingDevices -notcontains $deviceId) {
        try {
            New-MgGroupMember -GroupId $DeviceGroupObjectID -DirectoryObjectId $deviceId
            Write-Host "Added device $deviceId to group $DeviceGroupObjectID" -ForegroundColor Green
        } catch {
            Write-Host "Failed to add device $deviceId : $_" -ForegroundColor Red
        }
    }
}


if($noRemove){
    Write-Host "No devices will be removed from the group" -ForegroundColor Yellow
    return
}else{
    # Remove devices that are no longer relevant
    foreach ($deviceId in $existingDevices) {
        if ($allDevices -notcontains $deviceId) {
            try {
                Remove-MgGroupMemberByRef -GroupId $DeviceGroupObjectID -DirectoryObjectId $deviceId
                Write-Host "Removed device $deviceId from group $DeviceGroupObjectID" -ForegroundColor Yellow
            } catch {
                Write-Host "Failed to remove device $deviceId : $_" -ForegroundColor Red
            }
        }
    }
}


