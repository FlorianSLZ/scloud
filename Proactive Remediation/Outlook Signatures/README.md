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

# Synchronize Outlook Signatures with OneDrive using Intune Remediation

> Intune Proactive Remediation that syncs Outlook signatures between the local profile and a OneDrive redirected Documents folder.

## Overview

When the Documents folder is redirected to OneDrive (Known Folder Move), Outlook signatures can end up in different locations. This remediation detects that case and copies the local `%APPDATA%\Microsoft\Signatures` folder to OneDrive and back, so signatures stay available on every device of the user.

## What's included

| File | Description |
|------|-------------|
| `detection.ps1` | Checks whether the Documents folder path contains `OneDrive`. Exit `1` if remediation is needed. |
| `remediation.ps1` | Creates the local and OneDrive `Signatures` folders and copies the signatures in both directions. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations**.
2. Run it with the logged-on credentials (user context) in 64-bit PowerShell.
3. Assign it to your users with a daily schedule.

## Blog post

📖 Full guide: [Synchronize Outlook signatures](https://scloud.work/en/synchronize-outlook-signatures/)

## Related

- [Outlook stationery and fonts](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Outlook%20stationery%20and%20fonts) - standardize Outlook fonts and stationery

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
