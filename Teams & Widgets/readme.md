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

# Hide Teams Chat and Widgets in the Windows 11 Taskbar with Intune

> PowerShell scripts to hide the Teams chat and Widgets icons on the Windows 11 taskbar, deployable with Microsoft Intune.

## Overview

Two PowerShell scripts that remove the Widgets and Teams chat icons from the Windows 11 taskbar. One uses the device policy to disable Widgets, the other hides both icons for the current user. Deploy them with Microsoft Intune as platform scripts.

## What's included

| File | Description |
|------|-------------|
| `Disable-Widgets.ps1` | Sets `AllowNewsAndInterests = 0` under `HKLM\SOFTWARE\Policies\Microsoft\Dsh` (device, needs admin or system rights) |
| `Hide-Teams-and-Widgets.ps1` | Sets `TaskbarMn` (Teams chat) and `TaskbarDn` (Widgets) to `0` under `HKCU\...\Explorer\Advanced` (current user) |

## Usage

1. Add `Disable-Widgets.ps1` as an Intune platform script in the system context.
2. Add `Hide-Teams-and-Widgets.ps1` as a platform script that runs with the logged-on user's credentials.

## Blog post

📖 Full guide: [Windows 11 taskbar: Widgets and Chat](https://scloud.work/en/windows-11-taskbar-widgets-chat/)

## Related

- [Teams](https://github.com/FlorianSLZ/scloud/tree/main/Teams) - Microsoft Teams scripts and packages for Intune

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
