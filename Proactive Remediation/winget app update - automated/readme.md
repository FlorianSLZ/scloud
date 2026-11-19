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

# Automatically Create Winget Update Remediations in Intune

> PowerShell script that creates the winget based Proactive Remediation package for an app automatically in Microsoft Intune.

## Overview

Creating one winget update remediation per application by hand is repetitive. `procative-remediation-creation.ps1` automates it: you give it a name and a winget ID and it creates the remediation package in Intune, with schedule, run context and assigned Entra ID (Azure AD) group. It connects through the Microsoft Graph and AzureAD PowerShell modules, which it installs for the current user if they are missing.

## What's included

| File | Description |
|------|-------------|
| `procative-remediation-creation.ps1` | Creation script. Parameters include `-PAR_name`, `-winget_id`, `-PAR_AADGroup` (mandatory) and `-Publisher`, `-PAR_description`, `-PAR_RunAs`, `-PAR_Scheduler`, `-PAR_Frequency`, `-PAR_StartTime`, `-PAR_detection_path` and `-PAR_remediation_path` (optional). |

## Usage

```powershell
.\procative-remediation-creation.ps1 -PAR_name "Update 7-Zip" -winget_id "7zip.7zip" -PAR_AADGroup "APP-WIN-7zip"
```

By default the detection and remediation scripts are expected in `<script folder>\<PAR_name>\` as `detection-winget-upgrade.ps1` and `remediation-winget-upgrade.ps1` (see [winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update)). Defaults: run as `system`, daily schedule, start time `01:00`.

## Blog post

📖 Full guide: [Winget updates with Proactive Remediations](https://scloud.work/en/winget-updates-proactive-remediations/)

## Related

- [winget app update](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20app%20update) - the scripts used by this generator
- [winget upgrade all](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/winget%20upgrade%20all) - update all apps in one package

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
