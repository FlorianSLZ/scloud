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

# Uninstall the Teams Machine-Wide Installer with Intune Proactive Remediation

> Intune Proactive Remediation that detects and removes the classic Teams Machine-Wide Installer and its Chocolatey package.

## Overview

The Teams Machine-Wide Installer of the classic Teams client keeps reinstalling Teams for new users. After moving to the new Microsoft Teams, this remediation removes the installer from the device. If the Chocolatey package `microsoft-teams.install` exists, it is uninstalled as well.

## What's included

| File | Description |
|------|-------------|
| `detection.ps1` | Looks for "Teams Machine-Wide Installer" in `Win32_Product`. Exit `1` if installed. |
| `remediation.ps1` | Uninstalls the installer and removes `microsoft-teams.install` via Chocolatey when present. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations**.
2. Run it as SYSTEM in 64-bit PowerShell and assign it to your device group with a daily schedule.

## Blog post

📖 Full guide: [New Teams client and clean up the classic one with Intune](https://scloud.work/en/new-teams-client-and-cleanup-the-classic-intune/)

## Related

- [Clear Teams 2.x Cache](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Clear%20Teams%202.x%20Cache) - fix issues in the new Teams client

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
