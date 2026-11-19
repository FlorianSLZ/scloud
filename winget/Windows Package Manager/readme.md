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

# Deploy Windows Package Manager (winget) with Intune and PowerShell 7

> Win32 app that installs PowerShell 7 and repairs or updates the Windows Package Manager (winget) with the Microsoft.WinGet.Client module via Microsoft Intune.

## Overview

This winget package takes a different route than the MSIXBundle package: it installs the latest PowerShell 7 MSI from GitHub, installs the `microsoft.winget.client` module and runs `Repair-WinGetPackageManager`. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Downloads and installs the latest PowerShell 7 x64 MSI, then installs `microsoft.winget.client` and runs `Repair-WinGetPackageManager` in PowerShell 7. |
| `uninstall.ps1` | Removes the `Microsoft.DesktopAppInstaller` package. |
| `check.ps1` | Detection script: `winget.exe` exists and `winget -v` works. |
| `install.intunewin` | Ready-to-upload Intune package. |
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

- [winget program template](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template) - deploy any winget package
- [winget updater](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-updater) - keep winget apps updated

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
