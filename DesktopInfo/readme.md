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

# Show the Hostname on the Desktop with DesktopInfo and Microsoft Intune

> Win32 app package that deploys DesktopInfo via Microsoft Intune and displays the device name on every user's desktop at logon.

## Overview

[DesktopInfo](https://www.glenn.delahoy.com/desktopinfo/) shows system information on the desktop, independent of the wallpaper. This package copies `DesktopInfo64.exe`, a config file (`hostname.ini`) and a launch script to `C:\Program Files\DesktopInfo` and registers a scheduled task that starts it at logon for all users. It is useful for support scenarios and for devices without a physical label. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Copies the files, creates a VBScript helper that hides the PowerShell window, registers the logon task `DesktopInfo` for the Users group and writes a registry version key under `HKLM\SOFTWARE\scloud\DesktopInfo`. |
| `uninstall.ps1` | Removes the program folder and the scheduled task. |
| `check.ps1` | Detection script: scheduled task exists and `DesktopInfo64.exe` has file version 3.11.0. |
| `DesktopInfo64.exe` | The DesktopInfo application (64-bit). |
| `DesktopInfo.ps1` | Launch script, starts `DesktopInfo64.exe /ini=hostname.ini`. |
| `hostname.ini` | DesktopInfo configuration, shows the PC name in the bottom right corner. |
| `DesktopInfo.png` | App icon. |
| `DesktopInfo.intunewin` | Ready-to-upload Intune package. |

**Easy download:** click on the ZIP file (`DesktopInfo.zip`) and use the download button.

## Usage

1. Copy the files into one folder and package it with the [Microsoft Win32 Content Prep Tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) (`IntuneWinAppUtil.exe`, setup file `install.ps1`).
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. Make sure the `$ProgramPath` in `check.ps1` matches the install folder used by `install.ps1` (`C:\Program Files\DesktopInfo`).

## Blog post

📖 Full guide: [Hostname on the desktop with DesktopInfo](https://scloud.work/en/hostname-auf-desktop/)

## Related

- [BGInfo](https://github.com/FlorianSLZ/scloud/tree/main/BGInfo) - alternative: system info as wallpaper overlay
- [Wallpaper and lock screen](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Wallaper%20%26%20Lockscreen) - set company wallpaper and lock screen

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
