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

# Update HP Drivers and Firmware with Intune Proactive Remediation

> Intune Proactive Remediation that analyzes HP devices with HP Image Assistant and installs missing driver and firmware updates.

## Overview

This remediation package keeps HP drivers and firmware up to date through Microsoft Intune. The detection script runs HP Image Assistant (HPIA) in analyze mode and fails when recommendations exist; the remediation installs them silently. HP Image Assistant must be present on the device.

## What's included

| File | Description |
|------|-------------|
| `detection_HPUpdates.ps1` | Runs `HPImageAssistant.exe /Operation:Analyze /Action:List` for `Drivers,Firmware` and reads the JSON report. Exit `1` if recommendations exist or HPIA is missing. |
| `remediate_HPUpdates.ps1` | Runs HPIA with `/Action:Install /Silent /AutoCleanup` for the same categories and logs the installed recommendations. |

## Usage

1. Deploy HP Image Assistant to `C:\Program Files\HPImageAssistant`.
2. Adjust `$HPIA_category` if needed.
3. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell and schedule it.

## Blog post

📖 Full guide: [HP driver updates with Intune](https://scloud.work/en/hp-driver-intune/)

## Related

- [DELL Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/DELL%20Driver%20Updates) - same approach for Dell devices
- [Lenovo Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Lenovo%20Driver%20Updates) - Lenovo System Update draft

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
