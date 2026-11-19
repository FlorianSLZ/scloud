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

# Deploy Make Me Admin with Microsoft Intune via Chocolatey (Win32 App)

> Win32 app package that installs Make Me Admin via Chocolatey and Microsoft Intune to give users temporary local admin rights.

## Overview

Make Me Admin is a free tool from Sinclair Community College that gives standard users temporary local administrator rights on demand. This package installs it as an Intune Win32 app (system context). Policies can be set with the ADMX files and script in the `MakeMeAdmin` folder. This variant installs the `makemeadmin` Chocolatey package, so the [Chocolatey Win32 app](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey) must be deployed first.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Runs `choco install makemeadmin -y` (or `choco upgrade` if already installed). Optional parameters are read from `parameter.txt`, if present. |
| `uninstall.ps1` | Runs `choco uninstall makemeadmin -y`. |
| `check.ps1` | Detection script: folder `C:\ProgramData\chocolatey\lib\makemeadmin` exists. |
| `check.txt` | Detection rule in plain text. |
| `install.intunewin` | Ready-to-upload Intune package. |
| `makemeadmin.png` | App icon. |

**Easy download:** click on the ZIP file (`MakeMeAdmin-choco.zip`) and use the download button.

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.
6. Add the Chocolatey app as a dependency.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Make Me Admin (MSI variant)](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/MakeMeAdmin-MSI) - same app without Chocolatey
- [Make Me Admin policies](https://github.com/FlorianSLZ/scloud/tree/main/MakeMeAdmin) - ADMX templates and registry policy script
- [Chocolatey](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey) - required base package

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
