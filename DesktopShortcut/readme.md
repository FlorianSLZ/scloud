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

# Deploy Desktop Shortcuts to All Users with Microsoft Intune (Win32 App)

> Win32 app that creates shortcuts from a CSV list on the public desktop of every user through Microsoft Intune.

## Overview

The package creates `.lnk` shortcuts from `link-list.csv` (name, link, icon), adds any `.url` files from the `Desktop` folder and copies the result to `C:\Users\Public\Desktop`. Old shortcuts from the previous version of the package are removed first. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Removes old shortcuts, copies `Desktop\` and `icons\`, creates shortcuts from the CSV and copies them to the public desktop. Writes a version file. |
| `uninstall.ps1` | Removes the shortcuts of this package and the version file. |
| `check.ps1` | Detection script: version file matches `$Version`. |
| `link-list.csv` | Shortcut list with the columns `name,link,icon`. |
| `icons/` | Icon files referenced by the CSV (`scloud.ico`). |
| `Desktop/` | Prepared `.url` shortcuts that are copied as they are. |
| `DesktopShortcut.png` | App icon. |
| `install.intunewin` | Ready-to-upload Intune package. |

**Easy download:** click on the ZIP file (`DesktopShortcut.zip`) and use the download button.

## Usage

1. Add your shortcuts to `link-list.csv` and copy matching icons to `icons\`. Increase `$Version` in `install.ps1` and `check.ps1` whenever the list changes, so devices pick up the update.
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

## Blog post

📖 Full guide: [Manage desktop icons with Intune](https://scloud.work/en/manage-desktop-icon-intune/)

## Related

- [DesktopInfo](https://github.com/FlorianSLZ/scloud/tree/main/DesktopInfo) - show the hostname on the desktop

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
