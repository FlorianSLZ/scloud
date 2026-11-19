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

# Clear the New Microsoft Teams Cache On Demand with Intune Remediation

> On-demand Intune remediation that clears the new Microsoft Teams (2.x) cache, keeps custom backgrounds and restarts Teams.

## Overview

Cache corruption is a common cause of sign-in, loading and meeting problems in the new Microsoft Teams client. This script removes the content of the Teams package cache (`MSTeams_8wekyb3d8bbwe`) for the signed-in user. Custom background images are backed up first and restored afterwards. If Teams is running, the user sees a dialog and can confirm (**Clear**) or abort before Teams is closed and restarted.

## What's included

| File | Description |
|------|-------------|
| `ClearTeams2.xCache_DetectionAction.ps1` | Checks for the `ms-teams` process. If running, shows a confirmation dialog, stops Teams, clears the cache, restores the `Backgrounds` folder and starts Teams again. If Teams is not running, it only clears the cache. Logs to the IME log folder. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations** and upload the script as the detection script (it performs the action itself).
2. Set **Run this script using the logged-on credentials** to **Yes**.
3. Leave it unassigned and run it on demand per device via **Devices > select device > ... > Run remediation**.

## Blog post

📖 Full guide: [Teams cache cleanup on demand](https://scloud.work/en/teams-cache-cleanup-on-demand/)

## Related

- [Clear Microsoft Apps Cache](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Clear%20Microsoft%20Apps%20Cache) - same approach for Microsoft 365 Apps
- [Uninstall Teams Machinewide](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Uninstall%20Teams%20Machinewide) - clean up the classic Teams installer

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
