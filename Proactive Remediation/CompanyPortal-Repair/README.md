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

# Repair or Reinstall the Company Portal App with Intune (On-Demand Script)

> On-demand PowerShell script for Intune remediations that uninstalls and reinstalls the Windows Company Portal app with winget.

## Overview

When the Company Portal app is broken or missing, this script reinstalls it. It resolves the winget executable from the App Installer package, uninstalls the Microsoft Store app (ID `9WZDNCRFJ3PZ`) and installs it again silently. It is meant to be run on demand as a remediation in the system context.

## What's included

| File | Description |
|------|-------------|
| `OnDemand_CompanyPortal-Repair.ps1` | Runs `winget uninstall` and `winget install` for Company Portal, lists the result and writes a transcript to the IME log folder. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations** and upload the script as the detection script (it performs the action itself).
2. Run the script as SYSTEM (not with the logged-on credentials) in 64-bit PowerShell.
3. Leave it unassigned and run it per device via **Devices > select device > ... > Run remediation**.

Log: `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OnDemand_CompanyPortal-Repair.log`

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Proactive Remediation index](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - all remediations in this repository

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
