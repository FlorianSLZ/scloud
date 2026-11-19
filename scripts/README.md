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

# PowerShell Scripts for Microsoft Intune and Windows Management

> Index of PowerShell scripts and tools for Microsoft Intune, Autopilot and Windows device management by scloud.work.

## Overview

A collection of PowerShell scripts for Microsoft Intune and Windows device management. The larger tools have their own folder and README (Intune-Diag, Set-GroupByPrimaryUser, Start-SplashScreen, Set-TimeZoneByIPAddress, Secure Boot Certificate Renewal). The single `.ps1` files in this folder are meant to be deployed as Intune platform scripts, usually in the system context. The `WIN-S-D-` prefix stands for Windows, Script, Device. Most of them write a transcript to `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`.

## What's included

### Tools with their own README

| Folder | Description |
|--------|-------------|
| [`Intune-Diag`](Intune-Diag) | GUI tool to analyze Intune Management Extension and Autopilot logs |
| [`Set-GroupByPrimaryUser`](Set-GroupByPrimaryUser) | Sync an Entra ID device group with the primary users of a user group |
| [`Start-SplashScreen`](Start-SplashScreen) | Splash screen shown while scripts run during deployment |
| [`Set-TimeZoneByIPAddress`](Set-TimeZoneByIPAddress) | Set the Windows time zone from the public IP address |
| [`Secure Boot Certificate Renewal`](Secure%20Boot%20Certificate%20Renewal) | Detect and trigger the Secure Boot CA 2023 certificate update |

### Single scripts

| File | Description |
|------|-------------|
| `Autopilot-WelcomeMessage.ps1` | Registers a scheduled task that shows a localized (EN, DE, FR, IT) welcome and reboot message to the newly enrolled user; skipped if the enrollment is older than 24 hours |
| `Windows-Script-D-DeviceCleanup.ps1` | Windows 11 post-deployment configuration: location services and time zone, time service, BIOS key activation, Start menu and taskbar layout, bloatware removal and Intune log path rights |
| `WIN-S-D-DeviceOwnership.ps1` | Sets the `RegisteredOwner` and `RegisteredOrganization` registry values |
| `WIN-S-D-LAPS-Admin.ps1` | Creates an enabled local admin account with a random password (the account for Windows LAPS) |
| `WIN-S-D-NetworkConfigurationOperators.ps1` | Adds the logged-on user to the local Network Configuration Operators group, via a scheduled task at logon |
| `WIN-S-D-RemoveHPWolfSecurity.ps1` | Uninstalls HP Wolf Security, its console and the HP Security Update Service |
| `WIN-S-D-SecureBoot-CA2023-Update.ps1` | Checks the Secure Boot CA 2023 update and triggers it via the `AvailableUpdates` registry value and the Secure-Boot-Update scheduled task |
| `WIN-S-D-ServiceAutostart_SmartCardRemovalPolicy.ps1` | Sets the Smart Card Removal Policy service (`SCPolicySvc`) to automatic start |
| `WIN-S-D-WHfB-DisablePostLogonProvisioning.ps1` | Enables Windows Hello for Business and disables post-logon provisioning via the `PassportForWork` policy keys |

## Usage

1. In the Intune admin center, go to Devices > Scripts and remediations > Platform scripts.
2. Add the script and set "Run this script using the logged on credentials" as needed (the `WIN-S-D-` scripts are written for the system context) and run in 64-bit PowerShell.
3. Assign it to a device group and check the log in `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`.

Review each script and adjust values (account names, registry values, URLs) to your environment before you deploy it.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Proactive Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - detection and remediation scripts for Intune
- [Windows LAPS](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20LAPS) - Windows LAPS helper scripts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
