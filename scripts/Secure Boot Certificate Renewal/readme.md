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

# Secure Boot Certificate 2026 Renewal Monitoring with Intune (CA 2023)

> Intune detection and remediation scripts to monitor and trigger the Windows UEFI CA 2023 Secure Boot certificate update before the 2026 expiry.

## Overview

Microsoft is replacing the Secure Boot certificates that expire in 2026 with the new Windows UEFI CA 2023. These scripts help you detect and track that rollout on devices managed with Microsoft Intune. The detection script checks whether the new certificate is present in the Secure Boot database and reads the servicing status from the registry. The check-and-trigger script reports the same registry values and, if the update has not started, sets `AvailableUpdates` to `0x5944` so Windows can deliver the update. They run as Intune Proactive Remediation (detection) or as scripts on the device with administrator rights.

## What's included

| File | Description |
|------|-------------|
| `Remediation/Intune_SecureBoot_CA2023_Detection.ps1` | Detection script: compliant (exit 0) when `Windows UEFI CA 2023` is in the Secure Boot DB, or when `UEFICA2023Status` is `Updated` / `WindowsUEFICA2023Capable` is 2 and no error is set; otherwise exit 1 |
| `SecureBoot_CA2023_UpdateCheck_AndTrigger.ps1` | Checks the Secure Boot registry values and triggers the update by setting `AvailableUpdates = 0x5944` if the update is not done and the value is 0 or missing (exit 0 = updated or triggered, exit 1 = error) |

The related platform script [`WIN-S-D-SecureBoot-CA2023-Update.ps1`](https://github.com/FlorianSLZ/scloud/blob/main/scripts/WIN-S-D-SecureBoot-CA2023-Update.ps1) in the parent folder does a similar check-and-trigger as a single Intune platform script.

## Usage

1. In Intune, create a Proactive Remediation (Remediations) and use `Intune_SecureBoot_CA2023_Detection.ps1` as the detection script.
2. Use `SecureBoot_CA2023_UpdateCheck_AndTrigger.ps1` where you want the update triggered; run it as System / with administrator rights, since it writes to `HKLM`.
3. Review the device results in Intune to see which devices are updated, blocked or still waiting for the update from Windows Update.

Read the blog post first for background, risks and planning before triggering the update on production devices.

## Blog post

📖 Full guide: [Intune Secure Boot Certificate Updates](https://scloud.work/en/intune-secure-boot-certificate-updates/)

## Related

- [Proactive Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - more detection and remediation scripts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
