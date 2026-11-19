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

# Keep Chocolatey Apps Up to Date with Microsoft Intune (Scheduled Task)

> Win32 app that registers a scheduled task running choco upgrade all at startup and weekly, deployed through Microsoft Intune.

## Overview

After installing Chocolatey apps with Intune you still need a way to patch them. This package registers the task `Chocolatey Upgrade All` as SYSTEM. It runs `choco upgrade all -y` at startup and every Wednesday at 8 pm. Chocolatey must already be installed.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Checks that Chocolatey is installed and registers the scheduled task. |
| `uninstall.ps1` | Removes the scheduled task. |
| `check.ps1` | Detection script: the task exists and its description contains the package version. |
| `install.intunewin` | Ready-to-upload Intune package. |
| `Chocolatey Updater.png` | App icon. |

**Easy download:** click on the ZIP file (`chocolatey-updater.zip`) and use the download button.

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.
6. Add the Chocolatey app as a dependency.

## Blog post

📖 Full guide: [Keep Chocolatey programs up to date](https://scloud.work/en/keep-chocolatey-programs-up-to-date/)

## Related

- [Chocolatey](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey) - required base
- [winget updater](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-updater) - same idea for winget apps

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
