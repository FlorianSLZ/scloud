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

# Uninstall the New Outlook for Windows with Intune Proactive Remediation

> Intune Proactive Remediation that detects and removes the new Outlook for Windows (Microsoft.OutlookForWindows) app package.

## Overview

The new Outlook for Windows is delivered as an AppX package and can appear on devices through Windows updates. If you want to keep users on classic Outlook, this remediation detects the package and removes it, so it can be enforced on all devices through Microsoft Intune.

## What's included

| File | Description |
|------|-------------|
| `NEW-Outlook_uninstall-detection.ps1` | Looks for `Microsoft.OutlookForWindows` with `Get-AppxPackage`. Exit `1` if it is installed. |
| `NEW-Outlook_uninstall-remediation.ps1` | Removes the package with `Remove-AppxPackage`. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations**.
2. Run the scripts in the user context (logged-on credentials: **Yes**), since the package is installed per user, and in 64-bit PowerShell.
3. Assign it to your user or device group with a daily schedule.

## Blog post

📖 Full guide: [Handling the new Outlook with Intune](https://scloud.work/en/handling-the-new-outlook-with-intune/)

## Related

- [Unpin MS Store](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Unpin%20MS%20Store) - another app and taskbar clean-up remediation

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
