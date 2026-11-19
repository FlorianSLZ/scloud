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

# Random PowerShell Snippets for Windows, Intune and Hyper-V

> Small PowerShell scripts and registry files for Windows administration: scheduled tasks, feature update pinning, Hyper-V NAT and DHCP, and more.

## Overview

A mixed bag of small PowerShell scripts, registry files and snippets that did not fit anywhere else. Some are written for deployment as Intune platform scripts, others are for servers or lab setups. Check each file before you use it and adjust the values (names, times, IP ranges) to your environment.

## What's included

| File | Description |
|------|-------------|
| `DailyShutdownTask.ps1` | Registers a scheduled task "Daily Shutdown" that runs `Stop-Computer -Force` every day at 9 PM |
| `RebootTask.ps1` | Creates scheduled tasks with `schtasks` that reboot a server daily at 12:00, 21:30 and 00:00 and weekly on Sunday at 00:00 |
| `HyperV-with-DHCP.ps1` | Installs DHCP and Hyper-V, creates an internal virtual switch with NAT (10.1.97.0/24) and a DHCP scope for the VMs |
| `FeatureUpdate-TargetReleaseVersion-W11_23H2.reg` | Pins Windows 11 to feature update 23H2 (`TargetReleaseVersion`) |
| `FeatureUpdate-TargetReleaseVersion-W11_24H2.reg` | Pins Windows 11 to feature update 24H2 (`TargetReleaseVersion`) |
| `WIN-D-DownloadWallpaper.ps1` | Downloads a wallpaper image to `C:\Windows\Wallpaper.jpg` |
| `WIN-RegisteredOwnerOrganization.ps1` | Sets the `RegisteredOwner` and `RegisteredOrganization` registry values |
| `Start2.bin` | Start menu layout file for Windows 11 (used for Start menu cleanup) |

## Usage

1. Open the file you need and adjust the variables at the top.
2. For Intune, add the `.ps1` files as platform scripts and the `.reg` values via a script or a Settings Catalog policy.
3. Run scheduled task scripts with administrator rights.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [scripts](https://github.com/FlorianSLZ/scloud/tree/main/scripts) - PowerShell scripts for Intune and Windows management
- [Windows Updates for Business](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Updates%20for%20Business) - Windows Update for Business snippets

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
