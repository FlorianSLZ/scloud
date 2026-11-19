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

# Deploy-IntuneEnv: Baseline Microsoft Intune Policies (JSON)

> Exported baseline Microsoft Intune policies (compliance, configuration, settings catalog, BitLocker) as JSON for a planned deployment module.

## Overview

Work in progress for a PowerShell module that deploys a baseline Microsoft Intune environment. For now, the folder holds the `Data` directory with exported Intune policies as JSON, plus separate assignment files. The names and some descriptions are German (for example "Allgemein" = general, "Update-Richtlinie" = update policy). There is no module code yet.

## What's included

| Folder | Content |
|--------|---------|
| `Data/Administrative Templates` | Edge and OneDrive administrative template profiles |
| `Data/Device Compliance Policies` | "WIN Basic Requirements" compliance policy |
| `Data/Device Configurations` | General, AppLocker, Autopilot, health monitoring and Windows update profiles |
| `Data/Device Management Intents/BitLocker` | BitLocker endpoint security policy |
| `Data/Settings Catalog` | Defender antivirus, antivirus exclusions, Defender Firewall, Defender Security Experience and Outlook seamless setup policies |
| `Assignments` subfolders | Assignment JSON files for the policies (including Allow RDP, ASR, Client Security Baseline, EDR onboarding, Local Admin and Printer Restriction) |

## Usage

The JSON files are Microsoft Graph exports. You can review them or re-create the policies with the Graph API or an Intune backup and restore tool. Check IDs, names and assignments for your tenant first.

## Blog post

📖 Full guide: [Set up an Intune environment](https://scloud.work/en/setup-intune-environment/)

## Related

- [AppLocker](https://github.com/FlorianSLZ/scloud/tree/main/AppLocker) - AppLocker policy XML for Intune

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
