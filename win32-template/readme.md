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

# Intune Win32 App Template (PowerShell Install, Uninstall and Detection)

> Blank Win32 app template with PowerShell install, uninstall and detection scripts, including transcript logging, for Microsoft Intune.

## Overview

Start new Intune Win32 apps from this template. The install and uninstall scripts log to `C:\Program Files\_MEM\Log` (or the user's `%LOCALAPPDATA%\_MEM` for user-context installs). `check.ps1` collects several ready-to-use detection patterns: file exists, validation file with a version, file version, and more.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Install template: replace `PROGRAMNAME` and the `Start-Process` line with your installation routine. |
| `uninstall.ps1` | Uninstall template with the same structure. |
| `check.ps1` | Detection script examples (program file, validation file, file version). |

**Easy download:** click on the ZIP file (`win32-template.zip`) and use the download button.

## Usage

1. Replace `PROGRAMNAME` and the example installer calls in `install.ps1` and `uninstall.ps1`.
2. Keep only the detection block you need in `check.ps1`.
3. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`) and create the Win32 app in Intune.
4. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
5. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
6. Detection rule: custom script, upload `check.ps1`.

## Blog post

📖 Full guide: [How I create and test Win32 apps for Intune](https://scloud.work/en/how-i-create-and-test-win32-apps-for-intune/)

## Related

- [RunAsSystem](https://github.com/FlorianSLZ/scloud/tree/main/RunAsSystem) - test your install in the SYSTEM context
- [winget program template](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template) - ready-made template for winget apps
- [Chocolatey program template](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey-program-template) - ready-made template for Chocolatey apps

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
