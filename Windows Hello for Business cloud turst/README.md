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

# Windows Hello for Business Cloud Trust with Intune (Hybrid)

> Intune device configuration profiles and a PowerShell script to deploy Windows Hello for Business with hybrid cloud Kerberos trust.

## Overview

Intune device configuration profiles and a PowerShell script to set up Windows Hello for Business with hybrid cloud Kerberos trust. The script creates two profiles in Intune through the Microsoft Graph, one that activates Windows Hello for Business and one for the cloud trust setting. It uses the `Microsoft.Graph.Intune` module and the restore approach of the IntuneBackupAndRestore module by jseerden.

## What's included

| File | Description |
|------|-------------|
| `WH4B-Clout-trust_Intune.ps1` | Connects with `Connect-MSGraph` and creates the two device configuration profiles in Intune (profile JSON is embedded) |
| `Device Configurations/WIN WH4B activation.json` | Windows identity protection profile "WIN WH4B activation" (hybrid cloud trust) |
| `Device Configurations/WIN WH4B cloud trust.json` | Profile "WIN WH4B cloud trust" |
| `Windows Hello for Business cloud turst.zip` | ZIP with the same script and JSON files |

Easy download: click the ZIP file and use the download button.

## Usage

1. Install the module: `Install-Module -Name Microsoft.Graph.Intune -Scope CurrentUser`.
2. Run `WH4B-Clout-trust_Intune.ps1` and sign in with an account that can create device configuration profiles.
3. Assign the profiles to your devices in Intune.

## Blog post

📖 Full guide: [Windows Hello for Business cloud trust (hybrid)](https://scloud.work/en/windows-hello-for-business-cloud-trust-hybrid/)

## Related

- [Windows Hello](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Hello) - enable Windows Hello settings via script

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
