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

# Deploy a Registry Key as an Intune Win32 App

> Win32 app scripts for Microsoft Intune that set a registry value on install and revert it on uninstall.

## Overview

Packaging a registry change as a Win32 app gives you install status, detection and a clean uninstall in Microsoft Intune. The sample installs `HiberbootEnabled = 1` and the uninstall sets it back to `0`. Both scripts write a transcript to the Intune Management Extension log folder.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Creates the registry path if needed and sets the value (`$Value = "1"`). |
| `uninstall.ps1` | Sets the same value back (`$Value = "0"`). |
| `detection.ps1` | Custom detection script that reads the value from the registry. |

## Usage

1. Edit `$Path`, `$Key`, `$KeyFormat` and `$Value` in `install.ps1` and `uninstall.ps1`, and the matching values in `detection.ps1`. Check the logic of `detection.ps1` carefully: it currently exits `1` in every branch, so adapt it so a successful match returns exit code `0` and writes output.
2. Package the folder with the Win32 Content Prep Tool into an `.intunewin` file.
3. Install command: `powershell.exe -ExecutionPolicy Bypass -File install.ps1`
4. Uninstall command: `powershell.exe -ExecutionPolicy Bypass -File uninstall.ps1`
5. Detection rule: custom script `detection.ps1`. Run in system context and assign to a group.

## Blog post

📖 Full guide: [Registry key with Intune](https://scloud.work/en/registry-key-with-intune/)

## Related

- [Registry with Intune](https://github.com/FlorianSLZ/scloud/tree/main/Registry%20with%20Intune) - overview of all methods
- [Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Registry%20with%20Intune/Remediation) - same setting as a Proactive Remediation

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
