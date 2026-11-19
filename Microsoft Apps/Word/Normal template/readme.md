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

# Deploy a Default Word Normal.dotm Template with Microsoft Intune

> Win32 app that replaces the Word Normal.dotm template with a company version through Microsoft Intune, with a retry task if Word has the file locked.

## Overview

Documents should start with the right fonts, sizes and colors. Word reads these from `Normal.dotm` in `%APPDATA%\Microsoft\Templates`. This package copies your `Normal.dotm` there. If the file is locked by a running Word, it registers a SYSTEM scheduled task that retries at the next startup and returns exit code 1618 (retry). It runs as an Intune Win32 app.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Copies `Normal.dotm`, or registers the retry task if the copy fails; writes the detection registry key `HKLM\SOFTWARE\scloud\Packages\Normal-template`. |
| `uninstall.ps1` | Removes `Normal.dotm` from the Templates folder. |
| `check.ps1` | Detection script: version file matches `$Version`. |
| `Normal.dotm` | Word template. |
| `layout.png` | Preview image. |

**Easy download:** click on the ZIP file (`Normal template.zip`) and use the download button.

## Usage

1. Replace `Normal.dotm` with your template.
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection: the install script writes the registry key `HKLM\SOFTWARE\scloud\Packages\Normal-template` (value `Version`); use it as a registry detection rule. `check.ps1` is an alternative script rule based on a version file.
6. Add return code 1618 as *Retry* in the app.

## Blog post

📖 Full guide: [Normal.dotm with Intune](https://scloud.work/en/normal-dotm-intune/)

## Related

- [Excel template](https://github.com/FlorianSLZ/scloud/tree/main/Excel%20template) - default Excel templates
- [PowerPoint template](https://github.com/FlorianSLZ/scloud/tree/main/PowerPoint%20template) - default PowerPoint template
- [Outlook mail template](https://github.com/FlorianSLZ/scloud/tree/main/Normal%20mail%20template) - default mail template and font

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
