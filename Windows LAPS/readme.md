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

# Windows LAPS: Install the Required Windows Update with Intune

> A PowerShell script that installs the Windows update required for Windows LAPS on Windows 10 and Windows 11, for deployment with Microsoft Intune.

## Overview

Windows LAPS (Local Administrator Password Solution) needs a recent Windows update before it is available on Windows 10 and Windows 11. This script installs that update with the `PSWindowsUpdate` module, so you can deploy it with Microsoft Intune before you configure Windows LAPS with Entra ID.

## What's included

| File | Description |
|------|-------------|
| `WIN-LAPS-WindowsUpdate.ps1` | Installs `NuGet` and `PSWindowsUpdate`, detects Windows 10 or 11 and installs KB5025221 (Windows 10) or KB5025239 (Windows 11); logs to `LAPS-WindowsUpdate-script.log` |

## Usage

1. Add the script to Intune as a platform script and run it in the system context.
2. Check the log in `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\LAPS-WindowsUpdate-script.log`.
3. Configure the Windows LAPS policy after the update is installed.

## Blog post

📖 Full guide: [Windows LAPS update](https://scloud.work/en/windows-laps-update/)

## Related

- [scripts](https://github.com/FlorianSLZ/scloud/tree/main/scripts) - includes `WIN-S-D-LAPS-Admin.ps1`, which creates the local admin account for LAPS

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
