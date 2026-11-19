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

# Reinstall OneDrive with Microsoft Intune (Win32 App)

> Win32 app that uninstalls and reinstalls the OneDrive sync client on Windows devices through Microsoft Intune to fix a broken OneDrive installation.

## Overview

When OneDrive is corrupt or stuck, a clean reinstall often helps. `install.ps1` stops OneDrive, uninstalls it (system-wide or per user), downloads the current installer from Microsoft and installs it again. A temporary scheduled task serves as a one-time detection marker and deletes itself at the next startup. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Stops OneDrive, uninstalls it, downloads and installs the current client, and registers a temporary marker task. |
| `uninstall.ps1` | Removes the marker task `ReInstall_OneDrive`. |
| `check.ps1` | Detection script: scheduled task `ReInstall_OneDrive` exists. |
| `install.intunewin` | Ready-to-upload Intune package. |
| `OD-reinstall.jpg` | App icon. |

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1` (the marker task exists until the next startup). Assign the app as *required* to the affected devices or users.

The per-user uninstall branch calls PSADT functions (`Write-Log`, `Execute-ProcessAsUser`), which are only available if the script runs inside the PSAppDeployToolkit.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
