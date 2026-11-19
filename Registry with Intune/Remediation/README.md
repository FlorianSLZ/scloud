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

# Enforce a Registry Key with Intune Proactive Remediation

> Detection and remediation script pair for Microsoft Intune that checks a registry value and sets it when it differs.

## Overview

This remediation keeps a registry value at the desired state. The detection script reads the value and reports non-compliant (exit `1`) if it is missing or different; the remediation creates the key path if needed and sets the value. The sample sets `HiberbootEnabled` to `0` (disables Fast Startup).

## What's included

| File | Description |
|------|-------------|
| `detection_RegistryKey.ps1` | Reads `$Name` from `$Path` and compares it with `$Value`. Exit `0` if equal, `1` otherwise. |
| `remediation_RegistryKey.ps1` | Creates the path if missing and sets `$Key` with type `$KeyFormat` (DWORD) to `$Value`. |

## Usage

1. Edit the variables at the top of both scripts (path, name, type, value) and keep them in sync.
2. In Intune go to **Devices > Scripts and remediations**, create a package and upload both scripts.
3. For HKLM values run as SYSTEM in 64-bit PowerShell; for HKCU values use the logged-on credentials. Assign it with a schedule.

## Blog post

📖 Full guide: [Registry key with Intune](https://scloud.work/en/registry-key-with-intune/)

## Related

- [Registry with Intune](https://github.com/FlorianSLZ/scloud/tree/main/Registry%20with%20Intune) - overview of all methods
- [win32-RegistryKey](https://github.com/FlorianSLZ/scloud/tree/main/Registry%20with%20Intune/win32-RegistryKey) - same setting as a Win32 app

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
