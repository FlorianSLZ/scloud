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

# Set Windows Service Startup Type with Intune Proactive Remediation

> Intune Proactive Remediation template that sets a Windows service to Automatic and starts it, shown with the Smart Card Removal Policy service.

## Overview

Some Windows services must always be running, for example the Smart Card Removal Policy service (`SCPolicySvc`) for smart card based sign-in policies. This remediation checks the startup type and status of a service and corrects it. Change `$ServiceName` to reuse it for any other service.

## What's included

| File | Description |
|------|-------------|
| `ServiceStartupType_detection.ps1` | Exit `1` if `SCPolicySvc` is missing, not set to Automatic or not running. |
| `ServiceStartupType_remediation.ps1` | Sets the service to Automatic and starts it if needed. |

## Usage

1. Edit `$ServiceName` in both scripts.
2. Create a remediation package in **Devices > Scripts and remediations**.
3. Set **Run this script using the logged-on credentials** to **No**, **Enforce script signature check** to **No** and **Run script in 64-bit PowerShell** to **Yes**.

## Blog post

📖 Full guide: [Manage a Windows service with Intune](https://scloud.work/en/manage-windows-service-with-intune/)

## Related

- [Lenovo Intelligent Sensing Service](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Lenovo%20Intelligent%20Sensing%20Service) - same pattern, service set to Disabled

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
