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

# Clean Up Old User Profiles with Intune Proactive Remediation

> Intune Proactive Remediation that finds and removes user profiles that have not been used for more than 35 days.

## Overview

On shared or frequently changing devices, old user profiles fill up the disk. This remediation lists profile folders under `C:\Users` that were last written more than 35 days ago, skips local accounts and the Windows, Default, Public and Admin folders, and removes the matching profiles. The age limit is configurable with `$Profile_age`.

## What's included

| File | Description |
|------|-------------|
| `detection.ps1` | Collects stale profiles via `Win32_UserProfile` and exits with `1` if any are older than `$Profile_age` days. |
| `remediation.ps1` | Uses the same filter and removes the profiles with `Remove-CimInstance`. |

## Usage

1. Change `$Profile_age` (default `35` days) in both scripts if needed.
2. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell.
3. Test on a pilot group first, because profile deletion cannot be undone, then schedule it daily.

## Blog post

📖 Full guide: [User profile clean-up with Intune](https://scloud.work/en/user-profile-clean-up-intune/)

## Related

- [Free up disk space with Intune Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Free%20up%20disk%20space%20with%20Intune%20Remediation) - help users clear Downloads and Recycle Bin

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
