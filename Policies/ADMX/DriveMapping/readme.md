<p align="center">
  <a href="https://scloud.work/en/" title="scloud.work - Intune & Microsoft blog by Florian Salzmann">
    <img src="https://scloud.work/images/logo/terminal-logo-scloud.webp" alt="scloud logo" height="75" />
  </a>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/fsalzmann/"><img alt="Made by Florian Salzmann" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361"></a>
  <a href="https://scloud.work/en/"><img alt="Blog scloud.work" src="https://img.shields.io/static/v1?label=blog&message=scloud.work&color=0A66C2"></a>
  <a href="https://github.com/FlorianSLZ/scloud/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg"></a>
</p>

# Map Network Drives with Intune: Custom Drive Mapping ADMX

> A custom ADMX/ADML template to map network drives (D: to Z:) with Microsoft Intune administrative templates.

## Overview

A custom ADMX/ADML administrative template that adds drive mapping policies to Microsoft Intune. It lets you map network drives (UNC shares) with an Intune Administrative Templates profile through custom ADMX import, with one policy per drive letter from D: to Z:. A policy to show a notification when a mapped drive fails to reconnect is included as well.

## What's included

| File | Description |
|------|-------------|
| `DriveMapping.admx` | Policy definitions: category "Network Drive Mappings", the reconnect warning policy and drive policies `Drive_D` to `Drive_Z` |
| `DriveMapping.adml` | English language resources for the policies |
| `DriveMapping.zip` | ZIP with both files |

Easy download: click the ZIP file and use the download button.

## Usage

1. In the Intune admin center, go to Devices > Configuration > Import ADMX (Custom).
2. Upload `DriveMapping.admx` and `DriveMapping.adml` and wait until the status is "Available".
3. Create an Administrative Templates profile, find "Network Drive Mappings", set a drive letter to the UNC path of the share and assign the profile.

## Blog post

📖 Full guide: [Map network drives with Intune](https://scloud.work/en/intune-map-network-drive/)

## Related

- [Windows ADMX](https://github.com/FlorianSLZ/scloud/tree/main/Policies/ADMX/Windows) - fixes the Windows.admx namespace import error

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
