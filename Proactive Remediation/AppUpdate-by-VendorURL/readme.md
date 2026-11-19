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

# Update Apps via Vendor Download URL with Intune Proactive Remediation

> Proactive Remediation that compares the Last-Modified date of a vendor installer URL with the installed version and reinstalls the app when a newer build is online.

## Overview

Not every application is available in winget or Chocolatey. This example (written for the LehrerOffice desktop app, installed from a vendor URL) shows how to keep such apps up to date with Microsoft Intune: the detection script reads the `Last-Modified` header of the installer download and compares it with the install date in the registry. If the online file is newer, the remediation downloads and silently installs it. Adapt the URL and the `DisplayName` to your own application.

## What's included

| File | Description |
|------|-------------|
| `detection_new-LO-Version.ps1` | Sends a HEAD request to the installer URL and compares its `Last-Modified` date with the install date of the app in the uninstall registry key. Exit `1` if the app is missing or outdated. |
| `detection_DELAY-new-LO-Version.ps1` | Same check, but ignores installers published within the last 7 days (`$UpdateDelay`), so updates roll out with a delay. |
| `remediation_new-LO-install.ps1` | Downloads the EXE to `%TEMP%` and installs it silently (`/VERYSILENT /NORUN /NOCANCEL`), writing a log to the Intune Management Extension log folder. |

## Usage

1. Edit `$EXE_url` and the `DisplayName` filter (`LehrerOffice Desktop`) in the scripts to match your app. Make sure the installer supports silent switches.
2. Create a remediation package in **Devices > Scripts and remediations** with one of the two detection scripts plus the remediation script.
3. Run as SYSTEM in 64-bit PowerShell and assign it with a daily schedule.

## Blog post

📖 Full guide: [App update remediation](https://scloud.work/en/app-update-remediation/)

## Related

- [Winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update) - update apps by winget ID instead of a vendor URL
- [Choco Upgrade](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Choco%20Upgrade) - keep Chocolatey packages up to date

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
