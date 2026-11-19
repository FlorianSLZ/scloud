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

# Deploy Worksheet Crafter with Microsoft Intune (Win32 App)

> Win32 app package that installs Worksheet Crafter silently through Microsoft Intune with a custom install parameter.

## Overview

Worksheet Crafter is a teaching tool for creating worksheets. The installer is not included, so download `Worksheet_Crafter_Setup_Full.exe` from the vendor and place it next to the scripts. `install.ps1` takes the silent switches as a mandatory parameter, which you set in the Intune install command line. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Starts `Worksheet_Crafter_Setup_Full.exe` with the arguments passed in `-param`. |
| `uninstall.ps1` | Runs the Inno Setup uninstaller `unins000.exe` silently. |
| `check.ps1` | Detection script: `WorksheetCrafter.exe` has version 2022.2.7.135 or higher. |
| `Worksheet Crafter.png` | App icon. |

**Easy download:** click on the ZIP file (`Worksheet Crafter.zip`) and use the download button.

## Usage

1. Download `Worksheet_Crafter_Setup_Full.exe` and put it into this folder, then package it with the Win32 Content Prep Tool (setup file `install.ps1`).
2. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file .\install.ps1 -param "<silent installer switches>"`
3. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
4. Detection rule: custom script, upload `check.ps1`.

## Blog post

📖 Full guide: [Install Worksheet Crafter with Intune](https://scloud.work/en/install-worksheet-crafter-with-intune/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
