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

# Deploy Virtual Backgrounds for Classic Microsoft Teams with Intune

> Win32 app that copies company virtual backgrounds into the classic Microsoft Teams upload folder through Microsoft Intune.

## Overview

Classic Teams loads custom backgrounds from `%APPDATA%\Microsoft\Teams\Backgrounds\Uploads`. This package copies the images from `bg\` into that folder for the signed-in user. It runs as an Intune Win32 app in the **user** context. For the new Teams client use the other package.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Creates the Uploads folder, copies the images and writes a validation file. |
| `uninstall.ps1` | Removes the copied images and the validation file. |
| `check.ps1` | Detection script: validation file in `%LOCALAPPDATA%\_MEM\Validation` matches the version. |
| `bg/` | Background images (`scloud-bg-notext.jpg`). |
| `Teams-Backgrounds.png` | App icon. |

**Easy download:** click on the ZIP file (`Teams-Backgrounds.zip`) and use the download button.

## Usage

1. Put your images into `bg\`.
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Install behavior: **User**. Detection rule: custom script, upload `check.ps1`.

## Blog post

📖 Full guide: [Teams backgrounds (classic) with Intune](https://scloud.work/en/teams-background-classic/)

## Related

- [Teams-Backgrounds (new Teams)](https://github.com/FlorianSLZ/scloud/tree/main/Teams/Teams-Backgrounds) - version for the new Teams client

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
