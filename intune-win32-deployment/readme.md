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

# Automate Intune Win32 App Deployment with PowerShell and a Software List

> Software list plus PowerShell upload script that creates Win32 apps in Microsoft Intune automatically, including detection rules, icons and dependencies.

## Overview

If you maintain the same set of Win32 apps for many tenants, uploading the `.intunewin` file and filling in name, publisher and command lines by hand gets old quickly. This repository folder holds a CSV software list, ready-made app folders (mostly Chocolatey-based) and a PowerShell script that creates the apps in Microsoft Intune through the Graph API.

[![Watch the video](https://img.youtube.com/vi/RnYJl2QdiPk/0.jpg)](https://youtu.be/RnYJl2QdiPk)

## What's included

| File | Description |
|------|-------------|
| `Software-list.csv` | Semicolon-separated list of apps with `Name;description;install;uninstall;as;Dependency`. The script offers these rows for selection. |
| `_UploadWin32App/` | The PowerShell upload script, see its README. |
| `FIX_New-IntuneWin32AppDetectionRuleScript.ps1` | Patches the `IntuneWin32App` module (version 1.3.3) so that script detection rules are encoded correctly. |
| `7-Zip/` | Chocolatey-based package for 7-Zip. |
| `Chocolatey/` | Chocolatey base package (dependency for the other apps). |
| `Chocolatey Updater/` | Scheduled-task updater for Chocolatey apps; also contains `detection.ps1` and `remediation.ps1` for a Proactive Remediation with excluded apps. |
| `Putty/` | Chocolatey-based package for PuTTY. |
| `VLC/` | Chocolatey-based package for VLC media player. |
| `VSCode/` | Chocolatey-based package for Visual Studio Code. |

## Usage

1. Fill `Software-list.csv` and make sure every app has its own folder named exactly like the `Name` column, containing `install.ps1`, `uninstall.ps1` and `check.ps1` (and optionally an `install.intunewin`, `.png` or `.jpg` icon).
2. Run `_UploadWin32App\intune-win32-deployment.ps1`, enter your tenant prefix and the path to this folder, and select the apps in the grid view.
3. The script skips apps that already exist in Intune and adds dependencies (for example Chocolatey) automatically.
4. The `Software-list.csv` rows reference a Jabra Direct entry for which this folder has no app folder; add your own folder before you select it.

## Blog post

📖 Full guide: [Win32 app deployment automated](https://scloud.work/en/win32-app-deployment-automated/)

## Related

- [Upload script](https://github.com/FlorianSLZ/scloud/tree/main/intune-win32-deployment/_UploadWin32App) - the PowerShell script itself
- [Chocolatey](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey) - base package for Chocolatey apps
- [Win32 template](https://github.com/FlorianSLZ/scloud/tree/main/win32-template) - start a new app folder from a template

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
