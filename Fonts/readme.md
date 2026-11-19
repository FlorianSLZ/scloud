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

# Deploy Fonts with Microsoft Intune (Win32 App)

> Win32 app that installs company fonts (.ttf and .otf) for all users on Windows through Microsoft Intune.

## Overview

The package copies every `.ttf` and `.otf` file from the `Fonts` subfolder to `C:\Windows\Fonts` and registers it under `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts`. The folder ships with the Open Sans family as an example. It runs as an Intune Win32 app in the system context.

![Fonts preview](https://raw.githubusercontent.com/FlorianSLZ/scloud/main/Fonts/Fonts.jpg)

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Copies the fonts to `C:\Windows\Fonts`, registers them in the registry and writes a validation file. Returns exit code 1618 on error. |
| `uninstall.ps1` | Removes the registry entries and the validation file. |
| `check.ps1` | Detection script: validation file matches the version. |
| `Fonts/` | Font files (Open Sans: Light, Regular, Semibold, Bold, ExtraBold plus italics). |
| `Fonts.jpg` | Preview image. |

**Easy download:** click on the ZIP file (`Fonts.zip`) and use the download button.

## Usage

1. Replace the files in `Fonts\` with your own `.ttf` / `.otf` fonts.
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.
6. Increase `$Version` in `install.ps1` and `check.ps1` when you change the font set.

## Blog post

📖 Full guide: [Install fonts with Intune](https://scloud.work/en/install-fonts-with-intune/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
