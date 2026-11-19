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

# Deploy a Default Outlook Mail Template and Font with Microsoft Intune

> Win32 app that deploys NormalEmail.dotm and the default Outlook mail fonts for compose, reply and plain text through Microsoft Intune.

## Overview

Outlook uses `NormalEmail.dotm` as the template for new mails. This package copies the file to `%APPDATA%\Microsoft\Templates` and sets the compose, reply and plain-text font values in `HKCU\Software\Microsoft\Office\16.0\Common\MailSettings`. If Outlook has the template locked, the script asks the user to restart Outlook. It runs as an Intune Win32 app in the **user** context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Sets the mail font registry values, replaces `NormalEmail.dotm` (restarting Outlook if needed) and writes a validation file. |
| `uninstall.ps1` | Removes the template, the `MailSettings` registry key and the validation file. |
| `check.ps1` | Detection script: validation file in `%LOCALAPPDATA%\_MEM\Validation` matches the version. |
| `NormalEmail.dotm` | Mail template. |
| `normalmaildotm.png` | App icon. |

**Easy download:** click on the ZIP file (`Normal mail template.zip`) and use the download button.

## Usage

1. Adjust `NormalEmail.dotm` and the font byte values at the top of `install.ps1` (export them from a configured Outlook profile).
2. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Install behavior: **User**. Detection rule: custom script, upload `check.ps1`.

## Blog post

📖 Full guide: [NormalEmail.dotm mail template with Intune](https://scloud.work/en/mail-template-intune-normalmail-dotm/)

## Related

- [Word Normal template](https://github.com/FlorianSLZ/scloud/tree/main/Microsoft%20Apps/Word/Normal%20template) - default Word template
- [Excel template](https://github.com/FlorianSLZ/scloud/tree/main/Excel%20template) - default Excel templates and font

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
