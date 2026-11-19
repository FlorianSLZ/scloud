<p align="center">
  <a href="https://scloud.work/en/" title="scloud.work - Intune & Microsoft blog by Florian Salzmann">
    <img src="https://scloud.work/images/logo/terminal-logo-scloud.webp" alt="scloud logo" height="75" />
  </a>
</p>

<p align="center">
  <img src="https://scloud.work/images/logo/Set-GroupByPrimaryUser.webp" alt="Set-GroupByPrimaryUser logo" width="75" height="75" />
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/Set-GroupByPrimaryUser/"><img alt="PowerShell Gallery Version" src="https://img.shields.io/powershellgallery/v/Set-GroupByPrimaryUser.svg"></a>
  <a href="https://www.powershellgallery.com/packages/Set-GroupByPrimaryUser/"><img alt="PowerShell Gallery Downloads" src="https://img.shields.io/powershellgallery/dt/Set-GroupByPrimaryUser.svg"></a>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/fsalzmann/"><img alt="Made by Florian Salzmann" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361"></a>
  <a href="https://scloud.work/en/"><img alt="Blog scloud.work" src="https://img.shields.io/static/v1?label=blog&message=scloud.work&color=0A66C2"></a>
  <a href="https://github.com/FlorianSLZ/scloud/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg"></a>
</p>

# Set-GroupByPrimaryUser: Sync Entra ID Device Groups by Primary User

> Set-GroupByPrimaryUser is a PowerShell script that fills an Entra ID device group with the devices of a user group's primary users, using Microsoft Graph and Intune.

## Overview

Set-GroupByPrimaryUser synchronizes an Entra ID device group with the primary users of a source user group. It adds the devices of those users to the target group, removes devices that no longer belong (unless `-NoRemove` is set) and updates the group description with the device count. You can filter by operating system and by device ownership. It is a PowerShell script that uses the Microsoft Graph PowerShell SDK and is published on the PowerShell Gallery.

## What's included

| File | Description |
|------|-------------|
| `Set-GroupByPrimaryUser.ps1` | The sync script (published to the PowerShell Gallery) |
| `LICENSE` | License of the tool |

## Requirements

- PowerShell 7.x (recommended)
- Microsoft Graph PowerShell SDK (`Microsoft.Graph`)
- Permissions in Entra ID / Intune to read users and devices and to manage group members (the original guide lists Global Administrator or Intune Administrator)

## Usage

Install the script from the PowerShell Gallery:

```powershell
Install-Script -Name Set-GroupByPrimaryUser
```

Basic run, syncing the devices of all users in the source group into the target device group:

```powershell
Set-GroupByPrimaryUser -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>"
```

More examples:

```powershell
# Only Windows devices
Set-GroupByPrimaryUser -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -OSFilter "Windows"

# Company-owned Mac and iOS devices
Set-GroupByPrimaryUser -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -OSFilter "MacMDM", "iOS" -OwnershipFilter "Company"

# Never remove devices from the target group
Set-GroupByPrimaryUser -UserGroupObjectID "<UserGroupID>" -DeviceGroupObjectID "<DeviceGroupID>" -NoRemove
```

### Parameters

| Parameter | Required | Type | Description |
|-----------|----------|------|-------------|
| `-UserGroupObjectID` | Yes | `String` | Object ID of the user group to sync from |
| `-DeviceGroupObjectID` | Yes | `String` | Object ID of the device group to sync to |
| `-OSFilter` | No | `String[]` | Filter by OS: `Windows`, `MacMDM`, `iOS`, `Android`, `Linux` (default: all) |
| `-OwnershipFilter` | No | `String` | Filter by ownership: `Company` or `Personal` (default: all) |
| `-NoRemove` | No | `Switch` | Do not remove devices from the target group |

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
