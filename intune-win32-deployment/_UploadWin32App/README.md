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

# Upload Win32 Apps to Microsoft Intune with PowerShell (IntuneWin32App Module)

> PowerShell script that reads a software list, lets you pick apps and creates the Win32 apps in Microsoft Intune with detection rule, icon and dependency.

## Overview

`intune-win32-deployment.ps1` uses the `IntuneWin32App` module and the Microsoft Graph connection of `Connect-MSIntuneGraph`. For each selected app it builds the `.intunewin` file (or reuses an existing `install.intunewin`), creates an x64 requirement rule for Windows 10 2004 or later, uses `check.ps1` as the script detection rule and uploads the app. If a dependency is defined in the CSV, it is added as an auto-install dependency.

## What's included

| File | Description |
|------|-------------|
| `intune-win32-deployment.ps1` | Interactive upload script. Prompts for the tenant prefix and the software repo path, shows an `Out-GridView` to select apps from `Software-list.csv`, and uploads them. |

## Usage

1. Install the prerequisites: `Install-Module -Name IntuneWin32App -RequiredVersion 1.4.1 -Force` and `Install-Module Microsoft.Graph.Intune -Force`.
2. Change `$Publisher` in the script to your organisation name (default `scloud.work`).
3. Run the script. Enter the tenant prefix (for example `contoso` for `contoso.onmicrosoft.com`) and the path to the `intune-win32-deployment` folder, which must contain `Software-list.csv` and one folder per app.
4. Select the apps in the grid and confirm. Apps that already exist in Intune are skipped.
5. If the script detection rule upload fails with an older module version, see `FIX_New-IntuneWin32AppDetectionRuleScript.ps1` in the parent folder.

## Blog post

📖 Full guide: [Win32 app deployment automated](https://scloud.work/en/win32-app-deployment-automated/)

## Related

- [intune-win32-deployment](https://github.com/FlorianSLZ/scloud/tree/main/intune-win32-deployment) - software list and app folders

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
