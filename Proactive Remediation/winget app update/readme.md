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

# Update a Specific App with Winget using Intune Proactive Remediation

> Basic Intune Proactive Remediation that detects and upgrades a single app by its winget package ID.

## Overview

The simplest winget based update remediation. Set the winget ID of the app, and the detection script reports when `winget upgrade` lists an update for it. The remediation then upgrades only that app silently. Use one package per application.

## What's included

| File | Description |
|------|-------------|
| `detection-winget-upgrade.ps1` | Runs `winget upgrade` and exits with `1` if `$app_2upgrade` appears in the list. |
| `remediation-winget-upgrade.ps1` | Runs `winget upgrade --exact <id> --silent --force` with agreements accepted. |

## Usage

1. Replace the placeholder `WINGETPROGRAMID` in both scripts with the winget ID (find it with `winget search <name>`).
2. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell and schedule it daily.
3. To create many packages automatically, see [winget app update - automated](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update%20-%20automated).

## Blog post

📖 Full guide: [Winget updates with Proactive Remediations](https://scloud.work/en/winget-updates-proactive-remediations/)

## Related

- [winget app update with notification](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update%20with%20notification) - adds a toast notification
- [winget upgrade all](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20upgrade%20all) - update everything at once

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
