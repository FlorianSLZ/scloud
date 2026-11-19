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

# Intune Proactive Remediation Scripts: Community Repository

> Ready-to-use PowerShell detection and remediation scripts for Microsoft Intune Proactive Remediations (Remediations): app updates, clean-ups, driver updates, service fixes and more.

## Overview

Proactive Remediations (now called **Remediations** in the Intune admin center under **Devices > Scripts and remediations**) run a PowerShell detection script on your Windows devices and, if it reports a problem with exit code `1`, a remediation script that fixes it. This folder collects the packages I use and share on my blog. Every subfolder has its own README with the files, settings and usage. Proactive Remediations need Windows Enterprise or Education licensing; for Business tenants see [Proactive Remediation for Business](Proactive%20Remediation%20for%20Business).

## What's included

### App updates and software

| Folder | Description |
|--------|-------------|
| [winget app update](winget%20app%20update) | Detect and upgrade one app by winget ID |
| [winget app update - automated](winget%20app%20update%20-%20automated) | Script that creates winget update remediations in Intune automatically |
| [winget app update with notification](winget%20app%20update%20with%20notification) | Winget upgrade plus toast notification from SYSTEM |
| [winget upgrade all](winget%20upgrade%20all) | Run `winget upgrade --all` |
| [Choco Upgrade](Choco%20Upgrade) | Upgrade Chocolatey packages, pin selected apps |
| [AppUpdate-by-VendorURL](AppUpdate-by-VendorURL) | Update apps by comparing a vendor installer URL |
| [MS Apps - Force Update](MS%20Apps%20-%20Force%20Update) | Enforce a minimum Microsoft 365 Apps build |
| [7zip vulnerability](7zip%20vulnerability) | Remove the vulnerable 7-Zip help file |
| [CompanyPortal-Repair](CompanyPortal-Repair) | Reinstall the Company Portal app (on demand) |
| [NEW-Outlook_uninstall](NEW-Outlook_uninstall) | Remove the new Outlook for Windows |
| [Uninstall Teams Machinewide](Uninstall%20Teams%20Machinewide) | Remove the classic Teams Machine-Wide Installer |
| [WIN-PR-D-RetryFailedApps](WIN-PR-D-RetryFailedApps) | Retry failed Win32 app installs immediately |

### Drivers, firmware and device health

| Folder | Description |
|--------|-------------|
| [DELL Driver Updates](DELL%20Driver%20Updates) | Dell Command Update driver and firmware updates |
| [HP Driver Updates](HP%20Driver%20Updates) | HP Image Assistant driver and firmware updates |
| [Lenovo Driver Updates](Lenovo%20Driver%20Updates) | Lenovo System Update (draft) |
| [Lenovo Intelligent Sensing Service](Lenovo%20Intelligent%20Sensing%20Service) | Disable the SmartSense service that locks screens |
| [SecureBoot-CA2023-Update](SecureBoot-CA2023-Update) | Check and trigger the Secure Boot CA 2023 update |
| [WinRE-Size](WinRE-Size) | Extend the WinRE recovery partition |
| [Free up disk space with Intune Remediation](Free%20up%20disk%20space%20with%20Intune%20Remediation) | Help users free space before Windows 11 upgrades |
| [old Profile Monitor and Cleanup](old%20Profile%20Monitor%20and%20Cleanup) | Remove stale user profiles |
| [Service Startup Behavior](Service%20Startup%20Behavior) | Set a Windows service to Automatic and start it |

### User settings, cache and clean-up

| Folder | Description |
|--------|-------------|
| [Clear Microsoft Apps Cache](Clear%20Microsoft%20Apps%20Cache) | Clear the Microsoft 365 Apps cache on demand |
| [Clear Teams 2.x Cache](Clear%20Teams%202.x%20Cache) | Clear the new Teams cache on demand |
| [Unwanted Desktop Shortcuts](Unwanted%20Desktop%20Shortcuts) | Remove unwanted desktop shortcuts |
| [Unpin MS Store](Unpin%20MS%20Store) | Unpin the Microsoft Store from the taskbar |
| [OneDrive Desktop offline](OneDrive%20Desktop%20offline) | Keep the OneDrive Desktop folder available offline |
| [Outlook Signatures](Outlook%20Signatures) | Sync Outlook signatures with OneDrive |
| [Outlook stationery and fonts](Outlook%20stationery%20and%20fonts) | Enforce Outlook default fonts |
| [copy-logs](copy-logs) | Gather log files into the IME log folder |

### Tools and other approaches

| Folder / file | Description |
|---------------|-------------|
| [Proactive Remediation for Business](Proactive%20Remediation%20for%20Business) | Win32 app that runs remediation scripts via a scheduled task, no Enterprise license needed |
| `localTroubleshooting_Remediations.ps1` | Reads the stored remediation results (output of detection and remediation) from the Intune Management Extension registry on a device, for local troubleshooting |

## Usage

1. In the Intune admin center open **Devices > Scripts and remediations > Remediations** and create a script package.
2. Upload the detection and remediation script of the folder you want to use. Adjust the variables at the top of the scripts first.
3. Choose the run context (SYSTEM or logged-on user), 64-bit PowerShell and a schedule, then assign the package.
4. Use **Run remediation** on a device for on-demand scenarios and check the output in the remediation report.

## Blog post

📖 Full guide: [Proactive Remediation community repository](https://scloud.work/en/proactive-remediation-community-repository/)
📖 For Business licenses: [Proactive Remediation for Business](https://scloud.work/en/proactive-remediation-for-business/)

## Related

- [Compliance Policies](https://github.com/FlorianSLZ/scloud/tree/main/Compliance%20Policies) - custom compliance scripts for Intune
- [Registry with Intune](https://github.com/FlorianSLZ/scloud/tree/main/Registry%20with%20Intune) - enforce registry keys with a remediation, script or Win32 app

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
