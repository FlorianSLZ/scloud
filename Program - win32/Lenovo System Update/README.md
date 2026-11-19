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

# Deploy Lenovo System Update with Microsoft Intune (Win32 App)

> Two Win32 app packages for Microsoft Intune that install Lenovo System Update silently, either from the EXE installer or via winget.

## Overview

Lenovo System Update keeps drivers and firmware on Lenovo ThinkPad and ThinkCentre devices current. This folder contains two variants: one that wraps the offline EXE installer (version 5.07.0139) and one that installs the `Lenovo.SystemUpdate` package with winget. Both run as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `Lenovo System Update - EXE/install.ps1` | Installs `system_update_5.07.0139.exe` with `/verysilent /norestart`. |
| `Lenovo System Update - EXE/uninstall.ps1` | Runs `unins000.exe /VERYSILENT /NORESTART` from the System Update folder. |
| `Lenovo System Update - EXE/detection.txt` | Detection rule: `tvsu.exe` in `C:\Program Files (x86)\Lenovo\System Update\`, file version 5.7.0.139. |
| `Lenovo System Update - EXE/system_update_5.07.0139.exe` | Lenovo installer. |
| `Lenovo System Update - EXE/lenovo-system-update.png` | App icon. |
| `Lenovo System Update - winget/install.ps1` | Resolves `winget.exe` and installs `Lenovo.SystemUpdate` (machine scope, silent). |
| `Lenovo System Update - winget/uninstall.ps1` | Uninstalls `Lenovo.SystemUpdate` with winget. |
| `Lenovo System Update - winget/check.ps1` | Detection script: `winget list --id Lenovo.SystemUpdate --exact`. |
| `Lenovo System Update - winget/install.intunewin` | Ready-to-upload Intune package (winget variant). |
| `Lenovo System Update - winget/lenovo-system-update.png` | App icon. |

## Usage

1. Pick a variant: EXE (offline, no winget needed) or winget (always the current version, requires the [Windows Package Manager](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Windows%20Package%20Manager) on the device).
2. Package the variant folder with the Win32 Content Prep Tool (setup file `install.ps1`) and create a Win32 app in Intune.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection: for the winget variant upload `check.ps1` as a custom script. For the EXE variant use a file rule from `detection.txt`.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Windows Package Manager](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Windows%20Package%20Manager) - needed for the winget variant
- [Dell Command Update](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Dell%20Command%20Update) - same idea for Dell devices
- [HP Image Assistant](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/HP%20Image%20Assistant) - same idea for HP devices

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
