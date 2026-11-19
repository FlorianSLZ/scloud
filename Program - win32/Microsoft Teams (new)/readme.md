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

# Deploy the New Microsoft Teams Client with Microsoft Intune (Win32 App)

> Win32 app that provisions the new Microsoft Teams client for all users with the Teams bootstrapper and Microsoft Intune.

## Overview

The new Microsoft Teams client is installed machine-wide with `teamsbootstrapper.exe`. This package first removes the classic Teams for all users via the bootstrapper, then provisions the new client. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Runs `teamsbootstrapper.exe -u` (remove classic Teams for all users), then `-p` (provision new Teams). |
| `uninstall.ps1` | Runs `teamsbootstrapper.exe -x` to remove the new Teams client. |
| `detection.ps1` | Detection script: classic Teams is gone and the new Teams package (`MSTeams_*`) exists. |
| `teamsbootstrapper.exe` | Microsoft Teams bootstrapper. |
| `AppInfo.json` | App metadata (name, publisher, detection settings). |
| `MicrosoftTeams-new.png` | App icon. |
| `Microsoft Teams (new).intunewin` | Ready-to-upload Intune package. |

**Easy download:** click on the ZIP file (`Microsoft Teams (new).zip`) and use the download button.

## Usage

1. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`) or use the ready-made `.intunewin`.
2. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
3. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
4. Detection rule: custom script, upload `detection.ps1`.

## Blog post

📖 Full guide: [New Teams client and cleanup of classic Teams with Intune](https://scloud.work/en/new-teams-client-and-cleanup-the-classic-intune/)

## Related

- [Microsoft Teams (new) - Classic uninstall](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Microsoft%20Teams%20%28new%29%20-%20Classic%20uninstall) - also performs a deep cleanup of classic Teams
- [Teams: open in background](https://github.com/FlorianSLZ/scloud/tree/main/Teams/Teams_open-in-background) - start new Teams hidden at logon

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
