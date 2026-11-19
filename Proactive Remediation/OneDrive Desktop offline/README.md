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

# Keep the OneDrive Desktop Folder Offline Available with Intune Remediation

> Intune Proactive Remediation that makes the OneDrive for Business Desktop folder and its files always available offline.

## Overview

Users with Desktop folder redirection to OneDrive often need their files without network access. This remediation checks the file attributes in `%USERPROFILE%\OneDrive - <company>\Desktop` and pins the folder and all child items (Always keep on this device) with `attrib.exe`. A packaged variant for environments without Proactive Remediation licensing is in the subfolder `Win32_Business - Desktop offline`.

## What's included

| File | Description |
|------|-------------|
| `detection.ps1` | Checks the Desktop folder and every child item for the pinned attribute. Exit `1` if something is not available offline. |
| `remediation.ps1` | Sets the pinned attribute (`-U +P`) on the folder and all child items. |
| `Win32_Business - Desktop offline/` | Win32 app packaging with `install.ps1`, `uninstall.ps1`, `check.ps1` and the same detection/remediation scripts, plus a ZIP download. |

## Usage

1. Set `$CompanyName` (default `scloud`) and `$Folder` (default `Desktop`) in the scripts to match your OneDrive folder name.
2. Create a remediation package in **Devices > Scripts and remediations** and run it with the logged-on credentials.
3. For Business licenses without remediations, use the Win32 variant, which installs a scheduled task (see [Proactive Remediation for Business](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Proactive%20Remediation%20for%20Business)).

## Blog post

📖 Full guide: [OneDrive Desktop offline with Intune](https://scloud.work/en/onedrive-desktop-offline-intune/)

## Related

- [Proactive Remediation for Business](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Proactive%20Remediation%20for%20Business) - run remediations without the Enterprise license requirement

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
