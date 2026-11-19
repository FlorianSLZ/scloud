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

# Deploy a Default Excel Template and Font with Microsoft Intune

> Win32 app that deploys company Book.xltx and Sheet.xltx templates and sets the default Excel font for the user through Microsoft Intune.

## Overview

Excel uses `Book.xltx` and `Sheet.xltx` from the `XLSTART` folder as templates for new workbooks and new sheets. This package copies both files to `%APPDATA%\Microsoft\Excel\XLSTART` and sets the default font to `Arial,10` in the registry. It runs as an Intune Win32 app in the **user** context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Copies `Book.xltx` and `Sheet.xltx` to `XLSTART`, sets `HKCU\Software\Microsoft\Office\16.0\Excel\Options\Font` to `Arial,10` and writes a validation file. |
| `uninstall.ps1` | Removes both templates and the validation file. |
| `check.ps1` | Detection script: validation file in `%LOCALAPPDATA%\_MEM\Validation` matches the version. |
| `Book.xltx` | Workbook template. |
| `Sheet.xltx` | Worksheet template. |
| `Excel template.png` | App icon. |

**Easy download:** click on the ZIP file (`Excel template.zip`) and use the download button.

## Usage

1. Open `Book.xltx` and `Sheet.xltx` and adjust them to your corporate design. Change the font value in `install.ps1` if needed.
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Install behavior: **User**. Detection rule: custom script, upload `check.ps1`.
6. Increase `$Version` in `install.ps1` and `check.ps1` when you update the templates.

## Blog post

📖 Full guide: [Default Excel template with Intune](https://scloud.work/en/excel-default-template-intune/)

## Related

- [PowerPoint template](https://github.com/FlorianSLZ/scloud/tree/main/PowerPoint%20template) - default PowerPoint template
- [Word Normal template](https://github.com/FlorianSLZ/scloud/tree/main/Microsoft%20Apps/Word/Normal%20template) - default Word template
- [Outlook mail template](https://github.com/FlorianSLZ/scloud/tree/main/Normal%20mail%20template) - default mail template and font

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
