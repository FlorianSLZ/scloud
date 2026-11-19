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

# Deploy Any App with winget and Microsoft Intune (Win32 Template)

> Win32 app template that installs, detects and uninstalls any winget package silently through Microsoft Intune.

## Overview

Replace the placeholder `WINGETPROGRAMID` with the winget ID of your app (for example `Notepad++.Notepad++`). The scripts resolve `winget.exe` in the system context and install the package machine-wide. Extra winget parameters can be passed with `-param` in the install command line.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | `winget install --exact --id <ID> --silent --scope=machine`, optional extra arguments via `-param`. |
| `uninstall.ps1` | `winget uninstall --exact --id <ID> --silent`. |
| `check.ps1` | Detection script based on `winget list --id <ID> --exact`. |

**Easy download:** click on the ZIP file (`winget-program-template.zip`) and use the download button.

## Usage

1. Find the ID with `winget search <name>` and set `WINGETPROGRAMID` in `install.ps1`, `uninstall.ps1` and `check.ps1`.
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`.
6. Deploy the [Windows Package Manager](https://github.com/FlorianSLZ/scloud/tree/main/winget/Windows%20Package%20Manager) first (dependency).

## Blog post

📖 Full guide: [How to deploy winget with Intune](https://scloud.work/en/how-to-winget-intune/)

## Related

- [Windows Package Manager](https://github.com/FlorianSLZ/scloud/tree/main/winget/Windows%20Package%20Manager) - required base
- [winget updater](https://github.com/FlorianSLZ/scloud/tree/main/winget/winget-updater) - keep winget apps updated
- [Chocolatey program template](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey/chocolatey-program-template) - same approach with Chocolatey

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
