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

# Deploy Shared Network Printers with Microsoft Intune (PowerShell)

> PowerShell scripts to map shared printers from a print server and to allow non-admin printer driver installation (Point and Print) with Microsoft Intune.

## Overview

`Connect-SharedPrinter.ps1` maps printers from your print server for each user, removes unwanted printers and runs again at logon and on network changes through a scheduled task that it creates when run as SYSTEM. The second script turns off the Point and Print restriction so standard users can install printer drivers (after the PrintNightmare changes).

## What's included

| File | Description |
|------|-------------|
| `Connect-SharedPrinter.ps1` | Maps the shares listed in `$Prt_Shares` from `$Prt_Server`, optionally removes old printers, and registers a logon/network-change task for all users. |
| `Regkey_RestrictDriverInstallationToAdministrators_OFF.ps1` | Sets `RestrictDriverInstallationToAdministrators` to 0 under `HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint`. |

## Usage

1. In `Connect-SharedPrinter.ps1` set `$Prt_Server` and the printer share names in `$Prt_Shares`.
2. Run it once as SYSTEM through Intune (platform script or Win32 app). It saves itself locally and creates a scheduled task that maps the printers in each user's context.
3. Deploy `Regkey_RestrictDriverInstallationToAdministrators_OFF.ps1` as a platform script in the system context if users need to install drivers.

## Blog post

📖 Full guide: [Shared printers with Intune](https://scloud.work/en/shared-printer-intune/)  
📖 Full guide: [Point and Print with Intune](https://scloud.work/en/point-and-print-intune/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
