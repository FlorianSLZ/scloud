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

# Winget Upgrade All Apps with Intune Proactive Remediation

> Intune Proactive Remediation that detects available winget updates and runs winget upgrade --all on Windows devices.

## Overview

Instead of one package per app, this remediation upgrades everything winget can update. The detection script runs `winget upgrade` and flags the device when updates are listed; the remediation runs `winget upgrade --all`. This is convenient but gives you less control, so test it on a pilot group first.

## What's included

| File | Description |
|------|-------------|
| `detection-winget-upgrade-all.ps1` | Runs `winget upgrade` and exits with `1` if upgrades are available. |
| `remediation-winget-upgrade-all.ps1` | Runs `winget upgrade --all` (the silent and agreement flags are commented out and can be enabled). |

## Usage

1. Optionally enable `--silent --accept-package-agreements --accept-source-agreements` in the remediation script.
2. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell and schedule it.

## Blog post

📖 Full guide: [Winget updates with Proactive Remediations](https://scloud.work/en/winget-updates-proactive-remediations/)

## Related

- [winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update) - update one specific app
- [Choco Upgrade](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Choco%20Upgrade) - the Chocolatey equivalent

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
