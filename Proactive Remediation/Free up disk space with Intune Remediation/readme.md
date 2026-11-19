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

# Free Up Disk Space for Windows 11 Upgrades with Intune Remediation

> Intune Proactive Remediation that detects low disk space on drive C: and helps users clear Downloads and the Recycle Bin before a Windows 11 upgrade.

## Overview

Windows 11 feature updates fail when the system drive is too full. This remediation checks whether drive C: has at least 30 GB free. If not, and the Downloads folder plus the Recycle Bin hold more than 500 MB together, it shows the user a notification that explains why space is needed. The user can open both folders or let the script clean them automatically. Downloads is not backed up, so the dialog tells users to check it first. Both scripts run in the user context.

## What's included

| File | Description |
|------|-------------|
| `Detect-LowDiskSpace.ps1` | Checks free space on C: against `$MinGBFree` (30 GB) and the reclaimable size of Downloads and Recycle Bin against `$MinReclaimMB` (500 MB). Exit `1` triggers the remediation. |
| `Remediate-LowDiskSpaceUser.ps1` | Shows a popup with buttons to open Downloads and the Recycle Bin or to clean both. The header picture is embedded as Base64 and can be replaced. |

## Usage

1. Optionally adjust `$MinGBFree`, `$MinReclaimMB` and the texts or picture in the remediation script.
2. Create a remediation package in **Devices > Scripts and remediations**.
3. Set **Run this script using the logged-on credentials** to **Yes** and assign it to your Windows 11 upgrade group with a daily schedule.

## Blog post

📖 Full guide: [Free up space for Windows 11 upgrades with Intune remediation](https://scloud.work/en/free-up-space-for-windows-11-upgrades-with-intune-remediation/)

## Related

- [WinRE-Size](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/WinRE-Size) - make sure the recovery partition has enough space for updates
- [old Profile Monitor and Cleanup](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/old%20Profile%20Monitor%20and%20Cleanup) - remove stale user profiles to free disk space

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
