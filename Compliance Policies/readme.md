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

# Custom Compliance Policies for Windows in Microsoft Intune

> Example JSON and PowerShell pairs for Intune custom compliance policies on Windows: Credential Guard, registry values, services and files.

## Overview

Custom compliance in Microsoft Intune lets you mark Windows devices as compliant or not based on your own checks. A discovery PowerShell script returns its results as compressed JSON, and a compliance JSON file defines the rules for those values. The result can then be used in Conditional Access. Each subfolder holds one script and the matching JSON.

## What's included

| Folder / file | Description |
|---------------|-------------|
| `CredentialGuard OFF/` | `CredentialGuard OFF.ps1` and `.json`: reports whether Credential Guard is running (`DeviceGuardSecurityServicesRunning`). |
| `Generic Example/` | `Generic Example.ps1` and `.json`: template that returns multiple values (`Check1` boolean, `Check2` number). |
| `Registry Key/` | `Registry Key.ps1` and `.json`: reads the value `OnboardingState` from `HKLM:\SOFTWARE\CustomSecurity`. |
| `Service Is Running/` | `Service Is Running.ps1` and `.json`: checks that the Windows Update service (`wuauserv`) is running. |
| `Specific File/` | `Specific File.ps1` and `.json`: checks whether `C:\ProgramData\CustomApp\config.xml` exists. |
| `Trigger Custom Compliance Sync.ps1` | Starts a compliance sync with `intunemanagementextension://synccompliance`. |
| `WIN-S-D-CustomComplianceInterval-1h.ps1` | Creates the scheduled task "Custom Compliance Sync" that triggers the sync every 60 minutes as SYSTEM. |

## Usage

1. In the Intune admin center go to **Devices > Compliance > Scripts** (Compliance > Scripts) and add the discovery script, then adjust paths, names and values to your needs.
2. Create a Windows compliance policy, choose **Custom Compliance** and select the script plus the JSON file.
3. Assign the policy and optionally deploy the scheduled task script to sync more often than the default interval.

## Blog post

📖 Full guide: [Custom compliance for Windows in Intune](https://scloud.work/en/custom-compliance-windows-intune/)

## Related

- [Conditional Access](https://github.com/FlorianSLZ/scloud/tree/main/Conditional%20Access) - use compliance results in Entra ID policies
- [Proactive Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - fix what the compliance policy detects

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
