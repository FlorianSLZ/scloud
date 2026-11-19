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

# Deploy RunAsRob with Microsoft Intune (Part-Time Admin Tool)

> Win32 app package that installs RunAsRob and configures its registry policies so users can run approved programs as administrator via Microsoft Intune.

## Overview

RunAsRob lets standard users start allowed programs with administrator rights. This package installs `RunAsRob.exe` silently and then applies policy values (`AllowedPath`, `ServiceMode`, `LogonFlag`) in `HKLM\SOFTWARE\RunasRob` with `RunAsRob_Policies.ps1`. It runs as an Intune Win32 app in the system context.

![RunAsRob](https://raw.githubusercontent.com/FlorianSLZ/scloud/main/RunAsRob/RunAsAdmin.jpg)

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Runs `RunAsRob.exe /install /quiet`, then `RunAsRob_Policies.ps1`. |
| `uninstall.ps1` | Runs `RunAsRob.exe /uninstall /quiet`. |
| `check.ps1` | Detection script: `runasrob.exe` has version 4.2.0.0 or higher. |
| `RunAsRob_Policies.ps1` | Sets the policy registry values. Fill `$AllowedPath`, `$ServiceMode` and `$LogonFlag` (`asadmin` or `asservice`). |
| `RunAsRob.exe` | RunAsRob installer. |
| `RunAsAdmin.jpg` | Screenshot. |

**Easy download:** click on the ZIP file (`RunAsRob.zip`) and use the download button.

## Usage

1. Adjust the values in `RunAsRob_Policies.ps1` to your allowed paths.
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

## Blog post

📖 Full guide: [RunAsRob with Intune, the part-time admin](https://scloud.work/en/runasrob-intune-the-part-time-admin/)

## Related

- [Make Me Admin](https://github.com/FlorianSLZ/scloud/tree/main/MakeMeAdmin) - alternative for temporary local admin rights
- [RunAsSystem](https://github.com/FlorianSLZ/scloud/tree/main/RunAsSystem) - run commands as SYSTEM for testing

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
