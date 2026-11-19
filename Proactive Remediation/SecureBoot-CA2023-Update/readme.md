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

# Secure Boot CA 2023 Certificate Update with Intune Proactive Remediation

> Intune Proactive Remediation that checks the Secure Boot CA 2023 certificate rollout and triggers the update before the 2026 certificate expiry.

## Overview

The Microsoft Secure Boot certificates from 2011 expire in 2026 and are replaced by the Windows UEFI CA 2023. This remediation reports the rollout state per device and starts the update where it has not begun. It acts only when Secure Boot is enabled and the servicing status is `NotStarted`. Both scripts run as SYSTEM.

## What's included

| File | Description |
|------|-------------|
| `SecureBoot-CA2023-Update_Detection.ps1` | Compliant if `UEFICA2023Status` is `Updated` (with `WindowsUEFICA2023Capable` = 2), `InProgress`, or `NotStarted` with the trigger already set. Non-compliant if Secure Boot is disabled, the update has not started or the status is unknown. |
| `SecureBoot-CA2023-Update_Remediation.ps1` | Sets the `AvailableUpdates` trigger (`0x5944`) under `HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot` and starts the scheduled task `\Microsoft\Windows\PI\Secure-Boot-Update`. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations** and upload both scripts.
2. Set **Run this script using the logged-on credentials** to **No** and **Run script in 64-bit PowerShell** to **Yes**.
3. Assign it to a pilot group first, monitor the output in the remediation report, then roll out broadly. Some devices need a reboot and firmware support to complete the update.

## Blog post

📖 Full guide: [Intune Secure Boot certificate updates](https://scloud.work/en/intune-secure-boot-certificate-updates/)

## Related

- [Secure Boot Certificate Renewal (script)](https://github.com/FlorianSLZ/scloud/tree/main/scripts/Secure%20Boot%20Certificate%20Renewal) - standalone script version

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
