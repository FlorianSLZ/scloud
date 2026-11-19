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

# Deploy Notepad++ with PSAppDeployToolkit, winget and Microsoft Intune

> Win32 app for Microsoft Intune that deploys Notepad++ with the PSAppDeployToolkit (PSADT) and winget under the hood.

## Overview

This package wraps the PSAppDeployToolkit around winget. `Deploy-Application.ps1` resolves `winget.exe` and installs or uninstalls `Notepad++.Notepad++` silently, so you get PSADT logging and exit codes while winget supplies the current version. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `Deploy-Application.ps1` | PSADT script: installs `Notepad++.Notepad++` via winget, uninstalls it for the uninstall deployment type. |
| `Deploy-Application.exe` | PSADT launcher. |
| `AppDeployToolkit/` | PSAppDeployToolkit framework files. |
| `detection.ps1` | Detection script based on `winget list --id Notepad++.Notepad++ --exact`. |
| `Notepad++ (PSADT + winget).intunewin` | Ready-to-upload Intune package. |
| `notepad++-logo.png` | App icon. |

## Usage

1. Make sure the [Windows Package Manager](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Windows%20Package%20Manager) is available on the device.
2. Package the folder with the Win32 Content Prep Tool (setup file `Deploy-Application.exe`) or use the ready-made `.intunewin`.
3. Install command: `Deploy-Application.exe -DeploymentType "Install" -DeployMode "Silent"`
4. Uninstall command: `Deploy-Application.exe -DeploymentType "Uninstall" -DeployMode "Silent"`
5. Detection rule: custom script, upload `detection.ps1`.

## Blog post

📖 Full guide: [winget deployment with PSAppDeployToolkit and Intune](https://scloud.work/en/winget-deployment-with-psappdeploytoolkit-and-intune/)

## Related

- [winget program template](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-program-template) - plain winget Win32 template without PSADT
- [Windows Package Manager](https://github.com/FlorianSLZ/scloud/tree/main/winget/Windows%20Package%20Manager) - install winget itself

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
