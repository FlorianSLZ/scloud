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

# Deploy Make Me Admin with Microsoft Intune (MSI Win32 App)

> Win32 app package that installs the Make Me Admin MSI (version 2.3.0) silently via Microsoft Intune.

## Overview

Make Me Admin is a free tool from Sinclair Community College that gives standard users temporary local administrator rights on demand. This package installs it as an Intune Win32 app (system context). Policies can be set with the ADMX files and script in the `MakeMeAdmin` folder. This variant installs the MSI directly and needs no package manager.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Installs `MakeMeAdmin 2.3.0 x64.msi` with `/quiet`. |
| `uninstall.ps1` | Looks up the MSI product code of `Make Me Admin` and runs `msiexec /x ... /qn`. |
| `check.ps1` | Detection script: `MakeMeAdminService.exe` in `C:\Program Files\Make Me Admin\` has version 2.3.0.0 or higher. |
| `check.txt` | MSI detection rule in plain text (product code `{3E91EC56-D4F7-4EFE-A8BC-9633A3F4A179}`). |
| `MakeMeAdmin 2.3.0 x64.msi` | Installer. |
| `install.intunewin` | Ready-to-upload Intune package. |
| `makemeadmin.png` | App icon. |

**Easy download:** click on the ZIP file (`MakeMeAdmin-MSI.zip`) and use the download button.

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Make Me Admin (Chocolatey variant)](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/MakeMeAdmin-choco) - same app via Chocolatey
- [Make Me Admin policies](https://github.com/FlorianSLZ/scloud/tree/main/MakeMeAdmin) - ADMX templates and registry policy script

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
