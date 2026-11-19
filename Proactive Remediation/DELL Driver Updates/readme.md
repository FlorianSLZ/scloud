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

# Update Dell Drivers and Firmware with Intune Proactive Remediation

> Intune Proactive Remediation that scans Dell devices with Dell Command Update (dcu-cli) and installs missing driver and firmware updates.

## Overview

Keep Dell drivers and firmware current without touching each device. The detection script runs a Dell Command Update scan and fails if applicable updates are found; the remediation installs them silently, suspends BitLocker automatically and does not reboot. It runs as a Proactive Remediation from Microsoft Intune and requires Dell Command Update to be installed.

## What's included

| File | Description |
|------|-------------|
| `detection_DELLUpdates.ps1` | Runs `dcu-cli.exe /scan` for the configured categories (default `firmware,driver`) and evaluates the generated `DCUApplicableUpdates.xml`. Exit `1` if updates are available or Dell Command Update is missing. |
| `remediate_DELLUpdates.ps1` | Runs `dcu-cli.exe /applyUpdates -silent -reboot=disable -autoSuspendBitLocker=enable` and writes an update log to `C:\Temp\Dell_report`. |

## Usage

1. Deploy Dell Command Update to the devices (`C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe`).
2. Generate an encrypted password with `dcu-cli.exe /generateEncryptedPassword` and enter the key and password in `$DCU_encryptionKey` and `$DCU_encryptedPassword` in the remediation script (currently the placeholders `ADD ENC KEY` and `ADD ENC PWD`).
3. Adjust `$DCU_category` if needed (`bios,firmware,driver,application,others`).
4. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell and schedule it.

## Blog post

📖 Full guide: [Dell driver updates with Intune](https://scloud.work/en/dell-driver-with-intune/)

## Related

- [HP Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/HP%20Driver%20Updates) - same approach with HP Image Assistant
- [Lenovo Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Lenovo%20Driver%20Updates) - Lenovo System Update draft

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
