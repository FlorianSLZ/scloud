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

# Fix Lenovo Intelligent Sensing Service Locking Screens with Intune

> Intune Proactive Remediation that disables and stops the Lenovo Intelligent Sensing service (SmartSense) which can lock screens unexpectedly.

## Overview

On some Lenovo devices the Lenovo Intelligent Sensing Service (service name `SmartSense`) locks the screen when the user steps away or the sensor misbehaves. This remediation sets the service startup type to Disabled and stops it. Devices without the service are treated as compliant.

## What's included

| File | Description |
|------|-------------|
| `ServiceStartupType_LenovoIntelligentSensing_detection.ps1` | Exit `1` if the `SmartSense` service exists and is either not Disabled or still running. |
| `ServiceStartupType_LenovoIntelligentSensing_remediation.ps1` | Runs `Set-Service -StartupType Disabled` and stops the service if it is running. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations**.
2. Set **Run this script using the logged-on credentials** to **No**, **Enforce script signature check** to **No** and **Run script in 64-bit PowerShell** to **Yes**.
3. Assign the package to your Lenovo device group.

## Blog post

📖 Full guide: [Fix Lenovo Intelligent Sensing Service locking screens with Intune](https://scloud.work/en/fix-lenovo-intelligent-sensing-service-locking-screens-with-intune/)

## Related

- [Service Startup Behavior](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Service%20Startup%20Behavior) - the same pattern for any Windows service

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
