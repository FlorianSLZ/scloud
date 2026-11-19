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

# Set Outlook Stationery and Fonts with Intune Proactive Remediation

> Intune Proactive Remediation that detects and enforces Outlook default fonts and stationery stored in the registry.

## Overview

Outlook stores its default compose, reply and plain text fonts and the stationery as binary values in `HKCU\Software\Microsoft\Office\16.0\Common\MailSettings`. This package lets you capture the settings from a reference machine and enforce them on all users with Microsoft Intune. The `template` scripts are empty skeletons, the `example` scripts contain filled-in values.

## What's included

| File | Description |
|------|-------------|
| `Get-Font-Registry.ps1` | Reads the font and stationery values from the registry of the current user and prints them as variables you can paste into the template scripts. |
| `WIN-PR-U-OutlookFonts_detection - template.ps1` | Detection template: compares the registry byte arrays with the expected values. |
| `WIN-PR-U-OutlookFonts_remediation - template.ps1` | Remediation template: writes the expected values as binary registry entries. |
| `WIN-PR-U-OutlookFonts_detection - example.ps1` | Detection example with sample values. |
| `WIN-PR-U-OutlookFonts_remediation - example.ps1` | Remediation example with sample values. |

## Usage

1. Configure fonts and stationery in Outlook on a reference device and run `Get-Font-Registry.ps1`.
2. Paste the output into the variables of both template scripts.
3. Create a remediation package in **Devices > Scripts and remediations** and run it with the logged-on credentials (the settings live in HKCU).

## Blog post

📖 Full guide: [Mail template (normalmail.dotm) with Intune](https://scloud.work/en/mail-template-intune-normalmail-dotm/)

## Related

- [Outlook Signatures](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Outlook%20Signatures) - sync Outlook signatures

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
