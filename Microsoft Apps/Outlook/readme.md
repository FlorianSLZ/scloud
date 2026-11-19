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

# Disable Outlook Signature Synchronisation with Intune (PowerShell)

> PowerShell script that disables the Outlook cloud signature synchronisation by setting a registry value, ready for Microsoft Intune.

## Overview

New Outlook and Outlook for Microsoft 365 can roam signatures from the cloud. `Disable-OutlookSignatureSynchronisation.ps1` sets `DisableRoamingSignaturesTemporaryToggle` to 1 under `HKCU\Software\Microsoft\Office\16.0\Outlook\Setup`, so local signatures stay in control. Run it as a PowerShell script in Intune in the user context or as part of a Win32 app.

## What's included

| File | Description |
|------|-------------|
| `Disable-OutlookSignatureSynchronisation.ps1` | Creates the registry path if needed and sets `DisableRoamingSignaturesTemporaryToggle` (DWORD) to `1`. |

## Usage

1. In Intune go to **Devices > Scripts and remediations > Platform scripts** and add the script.
2. Set *Run this script using the logged on credentials* to **Yes**, then assign it to your users.

## Blog post

📖 Full guide: [Deactivate Outlook signature synchronisation](https://scloud.work/en/deactivate-outlook-signatur-synchronisation/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
