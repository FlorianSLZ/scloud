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

# Force Microsoft 365 Apps Updates with Intune Proactive Remediation

> Intune Proactive Remediation that checks the Microsoft 365 Apps build against a minimum version per update channel and triggers an update when it is too old.

## Overview

Use this remediation when Microsoft 365 Apps stay on an old build, for example after a security release. The detection script reads the installed version from the Click-to-Run configuration and compares it with the minimum version defined for your update channel. If the build is lower, the remediation starts `OfficeC2RClient.exe` with `/update user`.

## What's included

| File | Description |
|------|-------------|
| `Detect-M365AppUpdate.ps1` | Reads `VersionToReport` from `HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration` and compares it with the `$targetVersions` table (Current, Monthly Enterprise, Semi-Annual Enterprise and preview channels). |
| `Remediate-M365AppUpdate.ps1` | Starts `OfficeC2RClient.exe /update user` and waits for it to finish. |

## Usage

1. Update the `$targetVersions` values with the minimum builds from the [Microsoft 365 Apps version history](https://learn.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date#version-history).
2. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell.
3. Assign it with a daily schedule and re-check the target versions regularly.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Clear Microsoft Apps Cache](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Clear%20Microsoft%20Apps%20Cache) - fix Office add-in and sign-in problems

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
