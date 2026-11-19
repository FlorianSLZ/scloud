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

# Deploy Any App with Chocolatey and Microsoft Intune (Win32 Template)

> Win32 app template that installs, upgrades, detects and uninstalls any Chocolatey package silently through Microsoft Intune.

## Overview

Put the Chocolatey package ID into `choco.txt` and optional install parameters into `parameter.txt`. `install.ps1` installs the package, or upgrades it if it is already present. Chocolatey itself must be installed first, so use the Chocolatey Win32 app as a dependency.

## What's included

| File | Description |
|------|-------------|
| `choco.txt` | Chocolatey package ID (placeholder `chocoID`). |
| `parameter.txt` | Optional parameters passed to `choco install` (empty by default). |
| `install.ps1` | `choco install` or `choco upgrade` for the package in `choco.txt`. |
| `uninstall.ps1` | `choco uninstall` for the package in `choco.txt`. |
| `check.ps1` | Detection script: folder `C:\ProgramData\chocolatey\lib\<ID>` exists (set `$choco_id`). |

**Easy download:** click on the ZIP file (`chocolatey-program-template.zip`) and use the download button.

## Usage

1. Enter the package ID in `choco.txt` and in `check.ps1`; add parameters to `parameter.txt` if needed.
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`.
6. Add the [Chocolatey app](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey) as a dependency.

## Blog post

📖 Full guide: [Chocolatey program installation with Intune](https://scloud.work/en/chocolatey-program-installation/)

## Related

- [Chocolatey](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey) - required base
- [Chocolatey updater](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey-updater) - keep packages up to date
- [winget program template](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template) - same approach with winget

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
