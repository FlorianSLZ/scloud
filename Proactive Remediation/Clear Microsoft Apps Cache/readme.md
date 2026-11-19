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

# Clear the Microsoft 365 Apps Cache On Demand with Intune Remediation

> On-demand Intune remediation that clears the Microsoft 365 Apps (Office) cache and closes running Office apps after the user confirms.

## Overview

Add-in, sign-in and loading problems in Word, Excel, Outlook and other Microsoft 365 Apps are often fixed by clearing the Office web extension cache. This script clears the cache folder `%LOCALAPPDATA%\Microsoft\Office\16.0\Wef` for the signed-in user. If Office apps are running, a notification window asks the user to confirm before the apps are closed. It is designed as a Proactive Remediation that you trigger on demand from the Intune admin center.

## What's included

| File | Description |
|------|-------------|
| `ClearMSAppsCache_DetectionAction.ps1` | Looks for running Outlook, Word, Excel, PowerPoint, OneNote, Project and Visio processes. If found, shows a dialog with **Clear** and **Abort**; on confirmation it stops the apps and deletes the cache content. If no Office app is running, it clears the cache directly. Logs to the IME log folder. |

## Usage

1. Create a remediation package in **Devices > Scripts and remediations** and upload the script as the detection script. The script performs the action itself, so no separate remediation script is needed.
2. Set **Run this script using the logged-on credentials** to **Yes** (the cache and the dialog belong to the user).
3. Leave the package unassigned and run it per device via **Devices > select device > ... > Run remediation**.

## Blog post

📖 Full guide: [Cleaning up Microsoft Apps cache on demand with Intune](https://scloud.work/en/cleaning-up-microsoft-apps-cache-on-demand-with-intune/)

## Related

- [Clear Teams 2.x Cache](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Clear%20Teams%202.x%20Cache) - same approach for the new Microsoft Teams client

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
