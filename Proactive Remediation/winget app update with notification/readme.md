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

# Winget App Updates with Toast Notification using Intune Remediation

> Winget based Intune Proactive Remediation that upgrades an app and can notify the user with a toast notification, even from the SYSTEM context.

## Overview

This variant of the [winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update) remediation adds a toast notification script. It shows how to display a message to the signed-in user while the remediation runs as SYSTEM, using the RunAsUser module, which is embedded in the script so no module install is required.

## What's included

| File | Description |
|------|-------------|
| `detection-winget-upgrade.ps1` | Exit `1` if `winget upgrade` lists an update for `$app_2upgrade`. |
| `remediation-winget-upgrade.ps1` | Upgrades the app silently via winget. |
| `Toast_Remediation_SYSTEM_NoModuleInstall.ps1` | Extracts the header picture (Base64), a toast config XML and the RunAsUser module to `C:\Windows\Temp\Notification_System`, displays the toast to the user and optionally removes the module again. |

## Usage

1. Replace `WINGETPROGRAMID` with the winget ID in both winget scripts.
2. Customize the texts and the Base64 picture in the toast script and combine it with your remediation as needed.
3. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell.

## Blog post

📖 Full guide: [Winget updates with Proactive Remediations](https://scloud.work/en/winget-updates-proactive-remediations/)

## Related

- [winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update) - without notification
- [Free up disk space with Intune Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Free%20up%20disk%20space%20with%20Intune%20Remediation) - user notification in user context

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
