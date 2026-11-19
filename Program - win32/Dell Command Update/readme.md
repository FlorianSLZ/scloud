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

# Deploy Dell Command Update with Microsoft Intune (Win32 App)

> Win32 app package to install Dell Command Update 5.2.0 silently on Dell devices with Microsoft Intune and keep Dell drivers and BIOS updatable.

## Overview

Dell Command Update (DCU) is Dell's tool for driver, firmware and BIOS updates. This package installs the classic EXE edition silently and removes the UWP edition first, if present. It runs as an Intune Win32 app in the system context, for example on Autopilot devices.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Removes the UWP edition (`Dell Command*`) if found, then installs the EXE edition with `/s`. |
| `uninstall.ps1` | Silent uninstall of the EXE edition (`/passthrough /x /s /v"/qn"`). |
| `check.ps1` | Detection script: `dcu-cli.exe` must have file version 5.2.0 or higher. |
| `detection.txt` | Detection rule in plain text (file version 5.2.0, `C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe`). |
| `Dell-Command-Update-Application_4R78G_WIN_5.2.0_A00.EXE` | Dell installer (version 5.2.0). |
| `install.intunewin` | Ready-to-upload Intune package. |
| `dell-command-update.png` | App icon for the Intune portal. |

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

Logs are written to `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Dell-Command-Update-install.log`.

## Blog post

📖 Full guide: [Dell drivers with Intune](https://scloud.work/en/dell-driver-with-intune/)

## Related

- [HP Image Assistant](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/HP%20Image%20Assistant) - same idea for HP devices
- [Lenovo System Update](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Lenovo%20System%20Update) - same idea for Lenovo devices

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
