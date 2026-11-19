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

# Configure Make Me Admin Policies with Microsoft Intune (ADMX and Registry)

> ADMX/ADML templates and a PowerShell script to configure the Make Me Admin policies for temporary local admin rights via Microsoft Intune.

## Overview

Make Me Admin from Sinclair Community College gives users time-limited local administrator rights. Its settings live in `HKLM\SOFTWARE\Policies\Sinclair Community College\Make Me Admin`. `MakeMeAdmin_Policies.ps1` writes those values (allowed and denied entities, timeout, removal at logout, remote requests, syslog servers) from a JSON block, so you can set them from Intune without Group Policy. The ADMX files are included for Group Policy or Intune custom ADMX ingestion.

## What's included

| File | Description |
|------|-------------|
| `MakeMeAdmin_Policies.ps1` | Writes the policy values to the registry. Only entries with a value are set. Defaults: timeout 15 minutes, remove admin rights on logout, no remote requests. |
| `GroupPolicy/SinclairBase.admx` | Base ADMX template. |
| `GroupPolicy/SinclairMakeMeAdmin.admx` | Make Me Admin ADMX template. |
| `GroupPolicy/en-US/` | English ADML language files. |

## Usage

1. Edit the JSON block in `MakeMeAdmin_Policies.ps1` (for example `Allowed Entities`) and deploy the script as a platform script in the system context or inside the Make Me Admin Win32 app.
2. Alternatively, import the ADMX/ADML files into your Group Policy Central Store or Intune custom ADMX.
3. Install the application itself with one of the Win32 packages under Related.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Make Me Admin (MSI)](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/MakeMeAdmin-MSI) - install the application
- [Make Me Admin (Chocolatey)](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/MakeMeAdmin-choco) - install via Chocolatey
- [RunAsRob](https://github.com/FlorianSLZ/scloud/tree/main/RunAsRob) - alternative approach

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
