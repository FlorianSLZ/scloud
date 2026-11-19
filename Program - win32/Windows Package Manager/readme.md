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

# Install Windows Package Manager (winget) with Microsoft Intune (Win32 App)

> Win32 app that installs or repairs the Windows Package Manager (winget) on Windows devices through Microsoft Intune.

## Overview

winget is the base for many Intune app deployments. This package downloads the current `Microsoft.DesktopAppInstaller` MSIXBundle from `https://aka.ms/getwinget` and provisions it for all users with `Add-AppxProvisionedPackage`. It runs as an Intune Win32 app in the system context, for example during Autopilot.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Downloads the winget MSIXBundle to `C:\Program Files\_MEM\Data\WindowsPackageManager`, provisions it and cleans up. |
| `uninstall.ps1` | Removes the `Microsoft.DesktopAppInstaller` package. |
| `check.ps1` | Detection script: `winget.exe` exists in `WindowsApps`. |
| `AppInfo.json` | App metadata (name, install commands, registry detection). |
| `Windows Package Manager.png` | App icon. |

**Easy download:** click on the ZIP file (`Windows Package Manager.zip`) and use the download button.

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

## Blog post

📖 Full guide: [How to deploy winget with Intune](https://scloud.work/en/how-to-winget-intune/)

## Related

- [winget (repo folder)](https://github.com/FlorianSLZ/scloud/tree/main/winget/Windows%20Package%20Manager) - alternative version that installs PowerShell 7 and repairs winget
- [winget program template](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template) - deploy any winget package

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
