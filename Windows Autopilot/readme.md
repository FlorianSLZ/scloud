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

# Windows Autopilot Registration via App Registration (PowerShell)

> PowerShell scripts to register devices in Windows Autopilot with an Entra app registration and to check which tenant a device belongs to.

## Overview

PowerShell scripts for Windows Autopilot: register a device in Windows Autopilot through an Entra ID app registration, and find out which tenant a device is registered in. The registration scripts install the `Get-WindowsAutoPilotInfo` script and the `WindowsAutopilotIntune` module and upload the hardware hash online with an app ID and secret, so no interactive admin sign-in is needed. They are useful for technicians and in a pre-provisioning or OOBE shell.

## What's included

| File | Description |
|------|-------------|
| `Autopilot-Registration_viaAppReg.ps1` | Uploads the device's Autopilot hash to Intune with an app registration; the group tag is set in the script (`$GroupTag`) |
| `Autopilot-Registration_viaAppReg-UserInteraction.ps1` | Same, but prompts for an optional group tag |
| `Get-AutopilotProfileInfo.ps1` | Shows in which tenant a device is registered, read from the Autopilot profile data in the device registry; `-All` returns extended profile information |

## Usage

1. Create an app registration for Autopilot import in your tenant (see the blog post).
2. In the registration scripts, replace the placeholder `TenantId`, `AppId` and `AppSecret` values (and the group tag) with your own. Protect the secret, since it is stored in the script.
3. Run the script in an elevated PowerShell session on the device.
4. To check the tenant of a device, run:

   ```powershell
   .\Get-AutopilotProfileInfo.ps1
   .\Get-AutopilotProfileInfo.ps1 -All
   ```

## Blog post

📖 Full guide: [Autopilot Registration App](https://scloud.work/en/autopilot-registration-app/)

## Related

- [Set-TimeZoneByIPAddress](https://github.com/FlorianSLZ/scloud/tree/main/scripts/Set-TimeZoneByIPAddress) - set the time zone during Autopilot
- [Start-SplashScreen](https://github.com/FlorianSLZ/scloud/tree/main/scripts/Start-SplashScreen) - splash screen for deployment scripts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
