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

# Install New Teams and Uninstall Classic Teams with Intune (Win32 App)

> Win32 app for Microsoft Intune that removes classic Microsoft Teams, including the Machine-Wide Installer, and installs the new Teams client.

## Overview

This package migrates devices from classic Teams to the new Teams client. It removes the Teams Machine-Wide Installer, uninstalls classic Teams for every user profile, deletes old Teams folders and Start menu shortcuts, and then provisions the new client with `teamsbootstrapper.exe -p`. It runs in the system context as an Intune Win32 app.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Classic Teams cleanup for all users, then installs new Teams with the bootstrapper. |
| `uninstall.ps1` | Removes the new Teams client with `teamsbootstrapper.exe -x`. |
| `detection.ps1` | Detection script: classic Teams is gone and the new Teams package (`MSTeams_*`) exists. |
| `teamsbootstrapper.exe` | Microsoft Teams bootstrapper. |
| `AppInfo.json` | App metadata (name, publisher, detection settings). |
| `MicrosoftTeams-new.png` | App icon. |
| `Microsoft Teams (new) - Classic uninstall.intunewin` | Ready-to-upload Intune package. |

**Easy download:** click on the ZIP file (`Microsoft Teams (new) - Classic uninstall.zip`) and use the download button.

## Usage

1. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`) or use the ready-made `.intunewin`.
2. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
3. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
4. Detection rule: custom script, upload `detection.ps1`.

## Blog post

📖 Full guide: [New Teams client and cleanup of classic Teams with Intune](https://scloud.work/en/new-teams-client-and-cleanup-the-classic-intune/)

## Related

- [Microsoft Teams (new)](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Microsoft%20Teams%20%28new%29) - simple variant using only the bootstrapper
- [Teams cache cleanup](https://github.com/FlorianSLZ/scloud/tree/main/Microsoft%20Apps/Teams) - clear the Teams cache once

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
