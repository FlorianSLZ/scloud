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

# Remove Unwanted Desktop Shortcuts with Intune Proactive Remediation

> Intune Proactive Remediation that detects and deletes unwanted desktop shortcuts, such as Google Chrome or VLC, from the Public Desktop.

## Overview

Many installers drop shortcuts on the Public Desktop of every user. This remediation compares the files in the desktop folder with a list of unwanted shortcut names and deletes the matches. By default it checks `C:\Users\Public\Desktop` for `Google Chrome.lnk` and `VLC media player.lnk`.

## What's included

| File | Description |
|------|-------------|
| `detection.ps1` | Exit `1` if one of the shortcuts in `$Shortcuts2Remove` exists in `$DesktopPath`. |
| `remediation.ps1` | Removes the matching shortcuts. |

## Usage

1. Edit `$Shortcuts2Remove` and, if needed, `$DesktopPath` (for example `C:\Users\*\Desktop\*` for user desktops) in both scripts.
2. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell and schedule it daily.

## Blog post

📖 Full guide: [Proactively remove unwanted shortcuts](https://scloud.work/en/proactively-remove-unwanted-shortcuts/)

## Related

- [Unpin MS Store](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Unpin%20MS%20Store) - unpin the Store from the taskbar

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
