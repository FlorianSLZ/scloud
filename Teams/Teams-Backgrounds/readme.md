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

# Deploy Virtual Backgrounds for the New Microsoft Teams with Intune

> Win32 app that adds company virtual backgrounds to the new Microsoft Teams for every user through Microsoft Intune.

## Overview

The new Teams reads uploaded backgrounds from `%LOCALAPPDATA%\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams\Backgrounds\Uploads`. This package copies each image from `bg\` there, renamed to a GUID with a thumbnail, and remembers the names in `TeamsBackgrounds.csv` so that old images are replaced on update. It runs as an Intune Win32 app in the **user** context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Removes earlier backgrounds from this package, copies the new ones with GUID names and sets the registry version key `HKCU\SOFTWARE\scloud\Teams-new-Backgrounds`. |
| `uninstall.ps1` | Removes the copied backgrounds and the registry key. |
| `bg/` | Background images (`scloud-bg.jpg`). |
| `AppInfo.json` | App metadata with the install/uninstall commands and registry detection. |
| `Teams-virtual-backgrounds.png` | App icon. |

**Easy download:** click on the ZIP file (`Teams-Backgrounds.zip`) and use the download button.

## Usage

1. Put your images into `bg\`.
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Install behavior: **User**. Detection rule: registry, key `HKEY_CURRENT_USER\Software\scloud\Teams-new-Backgrounds`, value `Version` equals `1`.

## Blog post

📖 Full guide: [Virtual backgrounds for the new Teams with Intune](https://scloud.work/en/new-teams-virtual-background-with-intune/)

## Related

- [Teams-Backgrounds_classic](https://github.com/FlorianSLZ/scloud/tree/main/Teams/Teams-Backgrounds_classic) - version for classic Teams

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
