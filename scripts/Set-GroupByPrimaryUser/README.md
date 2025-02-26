<p align="center">
    <a href="https://scloud.work" alt="Florian Salzmann | scloud"></a>
            <img src="https://scloud.work/wp-content/uploads/Set-GroupByPrimaryUser.webp" width="75" height="75" /></a>
</p>
<p align="center">
    <a href="https://www.linkedin.com/in/fsalzmann/">
        <img alt="Made by" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361">
    </a>
    <a href="https://x.com/FlorianSLZ" alt="X / Twitter">
    	<img src="https://img.shields.io/twitter/follow/FlorianSLZ.svg?style=social"/>
    </a>
</p>
<p align="center">
    <a href="https://www.powershellgallery.com/packages/Set-GroupByPrimaryUser/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/Set-GroupByPrimaryUser.svg" />
    </a>
    <a href="https://www.powershellgallery.com/packages/Set-GroupByPrimaryUser/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/Set-GroupByPrimaryUser.svg" />
    </a>
</p>
<p align="center">
    <a href="https://raw.githubusercontent.com/FlorianSLZ/scloud/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/FlorianSLZ/Set-GroupByPrimaryUser.svg" />
    </a>
</p>

<p align="center">
	<a href='https://ko-fi.com/G2G211KJI9' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee' /></a>
</p>

# Set-GroupByPrimaryUser

The **Set-GroupByPrimaryUser** script is a PowerShell tool designed to automatically synchronize devices in an **Entra ID security group** based on the **primary users** from a specified user group. This ensures that devices are dynamically added or removed based on ownership and operating system filters.

## Features

- **Automatic Device Group Management**:  
  - Adds **new** devices owned by users in the source group.  
  - Optionally prevents removal of devices from the target group (`-NoRemove` switch).  

- **OS & Ownership Filtering**:  
  - Optionally filter devices based on **operating system** (`Windows`, `MacMDM`, `iOS`, `Android`, `Linux`).  
  - Filter by **device ownership** (`Company` or `Personal`).  

## Requirements

- **Windows OS**  
- **PowerShell 7.x** (recommended)  
- **Microsoft Graph PowerShell SDK** (`Microsoft.Graph`)  
- **Entra ID Global Administrator or Intune Administrator permissions**  

## Installation

For best experience before running the script, install the required **Microsoft Graph module**:

```powershell
Install-Script Set-GroupByPrimaryUser 
```

## Usage

### Basic Execution
Run the script to sync devices from a **user group** to a **device group**:

```powershell
Set-GroupByPrimaryUser -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>"
```

### Filtering by OS Type
Sync **only Windows** devices:

```powershell
Set-GroupByPrimaryUser -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -OSFilter "Windows"
```

Sync **Mac and iOS** devices:

```powershell
.\Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -OSFilter "MacMDM", "iOS"
```

### Filtering by Ownership Type
Sync **only company-owned devices**:

```powershell
.\Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -OwnershipFilter "Company"
```

Sync **personal Windows devices only**:

```powershell
.\Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -OSFilter "Windows" -OwnershipFilter "Personal"
```

### Prevent Device Removal (`-NoRemove`)
By default, the script removes devices that no longer belong in the target group. To prevent this, use the `-NoRemove` switch:

```powershell
.\Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -NoRemove
```

## Parameters

| Parameter         | Required | Type     | Description |
|------------------|----------|----------|-------------|
| `-UserGroupObjectID` | ✅ Yes | `String` | Entra ID **Object ID** of the **user group** to sync from. |
| `-DeviceGroupObjectID` | ✅ Yes | `String` | Entra ID **Object ID** of the **device group** to sync to. |
| `-OSFilter` | ❌ No | `String[]` | Filter devices by OS (`Windows`, `MacMDM`, `iOS`, `Android`, `Linux`). **Defaults to all OS types**. |
| `-OwnershipFilter` | ❌ No | `String` | Filter by **device ownership** (`Company`, `Personal`). **Defaults to all ownership types**. |
| `-NoRemove` | ❌ No | `Switch` | If set, **devices will not be removed** from the target group. |

## Example Scenarios

### Scenario 1: Sync All Devices (No Removal)
This command **syncs all devices** for users in the specified **user group** into the target **device group**, **without removing** any existing devices:

```powershell
Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "11111111-1111-1111-1111-111111111111" -DeviceGroupObjectID "22222222-2222-2222-2222-222222222222" -NoRemove
```

### Scenario 2: Sync Windows Devices Only
This command **syncs only Windows devices**, ignoring other OS types:

```powershell
Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "11111111-1111-1111-1111-111111111111" -DeviceGroupObjectID "22222222-2222-2222-2222-222222222222" -OSFilter "Windows"
```

### Scenario 3: Sync Company-Owned Mac & iOS Devices
This command **syncs only Mac and iOS devices that are company-owned**:

```powershell
Set-GroupByPrimaryUser.ps1 -UserGroupObjectID "11111111-1111-1111-1111-111111111111" -DeviceGroupObjectID "22222222-2222-2222-2222-222222222222" -OSFilter "MacMDM", "iOS" -OwnershipFilter "Company"
```

## Notes

- The script **requires Microsoft Graph authentication** to access Entra ID data.
- Run PowerShell with **administrative privileges** for best results.
- The device group description is updated after every run with the **device count and timestamp**.

This script **automates device group synchronization** based on **primary user relationships**, making it a **powerful tool for Entra ID & Intune management**. 🚀
