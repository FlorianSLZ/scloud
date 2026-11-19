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

# Retry Failed Win32 Apps Immediately with an Intune Remediation

> Intune Proactive Remediation that resets failed Win32 app installations so the Intune Management Extension retries them immediately instead of waiting up to 24 hours.

## Overview

Intune's Global Re-evaluation Schedule (GRS) delays retrying failed Win32 app installations for up to 24 hours. This remediation package lets you bypass that wait and trigger an immediate retry, either on a schedule or on demand per device.

- **Detection script** checks for failed Win32 app installation states in the IME registry.
- **Remediation script** removes the relevant app and GRS registry keys, then restarts the Intune Management Extension service.

This resets the retry counter so IME re-evaluates the app on the next sync.

## What's included

| File | Description |
|------|-------------|
| `RetryFailedApps_detection.ps1` | Finds failed Win32 app states in the IME registry; exit `1` if any exist. Log: `WIN-PR-D-RetryFailedApps_detection.log`. |
| `RetryFailedApps_remediation.ps1` | Removes the app and GRS registry keys of failed apps and restarts the IME service. Log: `WIN-PR-D-RetryFailedApps_remediation.log`. |

## Usage

1. In Intune, go to **Devices > Scripts and remediations** and create a new script package.
2. Upload `RetryFailedApps_detection.ps1` as the detection script and `RetryFailedApps_remediation.ps1` as the remediation script.
3. Set **Run this script using the logged-on credentials** to **No** (runs as SYSTEM).
4. Set **Run script in 64-bit PowerShell host** to **Yes**.

**On demand (recommended):** leave the package unassigned and trigger it per device via **Devices > select device > ... > Run remediation**.

**Scheduled:** assign it to a device group and run it daily or hourly, depending on your needs.

### Requirements

- Windows Enterprise or Education (E3/E5 or A3/A5)
- Microsoft Entra joined or hybrid joined
- Intune Management Extension installed on the device
- For on-demand runs: the device must be online and reachable via WNS

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [How I create and test Win32 apps for Intune](https://scloud.work/en/how-i-create-and-test-win32-apps-for-intune/) - blog guide on Win32 app packaging

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
