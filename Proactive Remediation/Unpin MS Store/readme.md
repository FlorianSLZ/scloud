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

# Unpin the Microsoft Store from the Taskbar with Intune Remediation

> Intune Proactive Remediation that detects the Microsoft Store icon pinned to the Windows taskbar and unpins it.

## Overview

This remediation keeps the Microsoft Store icon off the taskbar. The detection script lists the pinned apps through the Shell application and fails if an entry containing "store" is found; the remediation invokes the Unpin from taskbar verb for it.

## What's included

| File | Description |
|------|-------------|
| `unpin-MS-Store_detection.ps1` | Exit `1` if the Store is pinned to the taskbar, otherwise `0`. |
| `unpin-MS-Store_remediation.ps1` | Unpins the Store via the shell verb for the signed-in user. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations**.
2. Run it with the logged-on credentials (user context) in 64-bit PowerShell, since the taskbar belongs to the user.
3. Assign it to your users or devices.

## Blog post

📖 Full guide: [Remove the Microsoft Store icon from the taskbar with Intune](https://scloud.work/en/remove-the-microsoft-store-icon-from-taskbar-with-intune/)

## Related

- [Unwanted Desktop Shortcuts](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Unwanted%20Desktop%20Shortcuts) - remove desktop shortcuts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
