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

# Set Desktop Wallpaper and Lock Screen with Microsoft Intune (Win32 App)

> Win32 app that sets a company wallpaper and lock screen image on Windows 10/11 Pro and Business devices via the PersonalizationCSP registry keys and Microsoft Intune.

## Overview

On Windows Pro and Business editions the Intune policy for wallpaper and lock screen is not available. This package copies your images to `C:\Windows\System32` and sets the `PersonalizationCSP` registry values under `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion`. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Copies the images from `Data\` to `Desktop.jpg` / `Lockscreen.jpg` in `C:\Windows\System32`, sets the PersonalizationCSP values and writes a validation file. Image file names are set at the top of the script; leave one empty to skip it. |
| `uninstall.ps1` | Removes the PersonalizationCSP values and the validation file. |
| `check.ps1` | Detection script: reads the validation file `C:\ProgramData\scloud\Validation\Wallpaper` and compares its version. |
| `Data/` | Sample images (`wallpaper-scloud.jpg`, `wallpaper-scloud-rocket.jpg`, `scloud-banner.jpg`). |
| `install.intunewin` | Ready-to-upload Intune package. |
| `desktop.png` | Preview image. |

**Easy download:** click on the ZIP file (`Wallaper & Lockscreen.zip`) and use the download button.

## Usage

1. Replace the images in `Data\` with your own and adjust `$WallpaperIMG` and `$LockscreenIMG` in `install.ps1` (and `uninstall.ps1`).
2. Increase `$Version` in `install.ps1` and `check.ps1` whenever you change the images, so devices pick up the update.
3. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`) and create a Win32 app in Intune.
4. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
5. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
6. Detection rule: custom script, upload `check.ps1`.

## Blog post

📖 Full guide: [Wallpaper and lock screen with Intune on Business editions](https://scloud.work/en/wallpaper-lockscreen-intune-business/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
