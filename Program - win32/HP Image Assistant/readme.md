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

# Deploy HP Image Assistant with Microsoft Intune (Win32 App)

> Win32 app package that installs HP Image Assistant 5.1.7 silently via Microsoft Intune for driver and BIOS updates on HP devices.

## Overview

HP Image Assistant (HPIA) analyses HP devices and installs matching drivers, BIOS and firmware updates. This package extracts HPIA to `C:\Program Files\HPImageAssistant` and runs as an Intune Win32 app in the system context, for example during Autopilot.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Runs `hp-hpia-5.1.7.exe /s /e /f` to extract HPIA into `C:\Program Files\HPImageAssistant`. |
| `uninstall.ps1` | Removes the `HPImageAssistant` folder. |
| `check.ps1` | Detection script: `HPImageAssistant.exe` must have file version 5.1.7.138. |
| `detection.txt` | Detection rule in plain text. |
| `hp-hpia-5.1.7.exe` | HP installer (version 5.1.7). |
| `install.intunewin` | Ready-to-upload Intune package. |
| `HP Image Assistant.png` | App icon for the Intune portal. |

**Easy download:** click on the ZIP file (`HP Image Assistant.zip`) and use the download button.

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

Logs are written to `C:\Program Files\_MEM\Log\`.

## Blog post

📖 Full guide: [HP drivers with Intune](https://scloud.work/en/hp-driver-intune/)

## Related

- [Dell Command Update](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Dell%20Command%20Update) - same idea for Dell devices
- [Lenovo System Update](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Lenovo%20System%20Update) - same idea for Lenovo devices

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
