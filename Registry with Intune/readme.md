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

# Set Registry Keys with Microsoft Intune: Script, Remediation or Win32 App

> Three ways to enforce a Windows registry value with Microsoft Intune: a platform script, a Proactive Remediation and a Win32 app.

## Overview

Registry values are often the only way to configure a setting that has no policy. Intune offers several ways to deploy them and the best one depends on whether the value must be re-applied and how you want to report it. All examples set `HiberbootEnabled` in `HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power` (Fast Startup) as a sample; change the path, name, type and value to yours.

## What's included

| Folder / file | Description |
|---------------|-------------|
| `Set-RegistryKey.ps1` | Standalone script for the Intune platform scripts feature. Creates the path if needed and sets the value, with a transcript in the IME log folder. |
| [`Remediation/`](Remediation) | Detection and remediation pair that checks the value and re-applies it on a schedule. |
| [`win32-RegistryKey/`](win32-RegistryKey) | Win32 app with install, uninstall and detection scripts for a trackable deployment. |

## Usage

1. Choose a method:
   - **Platform script** (`Set-RegistryKey.ps1`): runs once per device or user, simplest option.
   - **Remediation**: checks regularly and corrects drift.
   - **Win32 app**: install/uninstall and detection rule, shows up as an app with status.
2. Edit `$Path`, `$Key`, `$KeyFormat` and `$Value` in the scripts of the method you picked.
3. Deploy via the matching Intune area and assign it to a group.

## Blog post

📖 Full guide: [Registry key with Intune](https://scloud.work/en/registry-key-with-intune/)

## Related

- [Proactive Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - more remediation packages

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
