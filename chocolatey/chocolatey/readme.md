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

# Deploy Chocolatey with Microsoft Intune (Win32 App)

> Win32 app that installs the Chocolatey package manager on Windows devices through Microsoft Intune as the base for further Chocolatey apps.

## Overview

Chocolatey is a package manager for Windows. This Win32 app installs it with the official install script if `choco.exe` is missing, enables `useRememberedArgumentsForUpgrades` and sets a registry detection key defined in `AppInfo.json`. It runs in the system context and is meant as a dependency for other Chocolatey-based apps.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Installs Chocolatey if needed, enables remembered upgrade arguments and writes the detection registry key. |
| `check.ps1` | Detection script: Chocolatey version 2.0 or higher is installed. |
| `AppInfo.json` | App metadata (name, install command, registry detection). |
| `install.intunewin` | Ready-to-upload Intune package. |
| `Chocolatey.png` | App icon. |

**Easy download:** click on the ZIP file (`chocolatey.zip`) and use the download button.

## Usage

1. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`) or use the ready-made `.intunewin`.
2. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
3. Uninstall: not provided by this package.
4. Detection rule: custom script, upload `check.ps1`.
5. Use this app as a dependency for Chocolatey-based Win32 apps.

## Blog post

📖 Full guide: [Chocolatey basics with Intune](https://scloud.work/en/chocolatey-basics-with-intune/)

## Related

- [Chocolatey program template](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey-program-template) - deploy any Chocolatey package
- [Chocolatey updater](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey-updater) - keep packages up to date

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
