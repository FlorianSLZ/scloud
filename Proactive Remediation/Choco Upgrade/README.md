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

# Keep Chocolatey Packages Up to Date with Intune Proactive Remediation

> Proactive Remediation that upgrades outdated Chocolatey packages on Windows devices and pins selected apps to a fixed version.

## Overview

If you deploy software with Chocolatey, this Intune remediation package keeps it current. The detection script checks `choco outdated` and the pin list; the remediation upgrades everything that is outdated while excluding apps you want to hold back. Excluded apps are pinned to a specific version (and installed at that version if a different one is present).

## What's included

| File | Description |
|------|-------------|
| `detection_choco-upgrade.ps1` | Compares the apps in `$ChocoApps_not2Upgrade` with the pinned apps and runs `choco outdated`. Exit `1` if pins differ or upgrades are available. |
| `remediation_choco-upgrade.ps1` | Pins the excluded apps (installing the defined version if needed) and runs `choco upgrade` for all other outdated packages. |

## Usage

1. Make sure Chocolatey is installed on the devices (`C:\ProgramData\chocolatey\choco.exe`).
2. Adjust the `$ChocoApps_not2Upgrade` list (name and version) in both scripts. The sample entries are `snagit` and `veyon`.
3. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell and schedule it (for example daily).

## Blog post

📖 Full guide: [Keep Chocolatey programs up to date](https://scloud.work/en/keep-chocolatey-programs-up-to-date/)

## Related

- [Winget upgrade all](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20upgrade%20all) - the winget equivalent
- [Winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update) - update a single app via winget

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
