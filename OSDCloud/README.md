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

# OSDCloud: Build a Custom Windows 11 Deployment ISO

> A PowerShell script that builds a custom OSDCloud WinPE ISO to deploy Windows 11 from the cloud.

## Overview

A PowerShell script that builds a custom OSDCloud WinPE boot image and ISO for deploying Windows 11 over the cloud. It creates a German/Swiss template, sets up a workspace under `%TEMP%\OSDCloud`, edits the WinPE startnet so it starts `Start-OSDCloud` for Windows 11 22H2 Pro (de-de, Retail license), adds branding and cloud drivers, and then builds the ISO. It is a personal sample, so adjust language, OS version, brand and wallpaper path before you use it.

## What's included

| File | Description |
|------|-------------|
| `OSDCloud_Basic-Image.ps1` | `New-OSDCloudTemplate`, `Set-OSDCloudWorkspace`, `Edit-OSDCloudWinPE` (startnet, brand, wallpaper, `-CloudDriver *`) and `New-OSDCloudISO` |

## Requirements

- Windows ADK and the WinPE add-on for the ADK
- The `OSD` PowerShell module: `Install-Module OSD -Force`

## Usage

1. Install the ADK, the WinPE add-on and the `OSD` module.
2. Edit the language, OS version and branding values in `OSDCloud_Basic-Image.ps1`.
3. Run the script. The new ISO is created in the OSDCloud workspace folder.
4. Boot a device from the ISO to deploy Windows.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Start-SplashScreen](https://github.com/FlorianSLZ/scloud/tree/main/scripts/Start-SplashScreen) - splash screen for deployment scripts
- [Windows Autopilot](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Autopilot) - register devices in Windows Autopilot

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
