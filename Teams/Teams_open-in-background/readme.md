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

# Open Microsoft Teams in the Background at Logon with Intune (PowerShell)

> PowerShell scripts that switch the new and classic Microsoft Teams to start in the background, deployable with Microsoft Intune.

## Overview

Both scripts use the RunOnce pattern in the user's registry. On the first run they save themselves locally and register a RunOnce entry. At the next logon they stop Teams and flip the app setting: `open_app_in_background` in `app_settings.json` for the new Teams, `openAsHidden` in `desktop-config.json` for classic Teams (which is then restarted hidden). Run them in the user context.

## What's included

| File | Description |
|------|-------------|
| `Teams_open-in-background.ps1` | New Teams: sets `open_app_in_background` to true. |
| `Teams-Classic_open-in-background.ps1` | Classic Teams: sets `openAsHidden` to true and restarts Teams in the background. |

## Usage

1. Deploy the script that matches your Teams client as an Intune platform script in the user context (*Run this script using the logged on credentials: Yes*).
2. On the next logon the setting is changed once. Change `$Version` in the script to apply it again.

## Blog post

📖 Full guide: [Open the new Teams in the background](https://scloud.work/en/how-to-open-new-teams-in-background/)  
📖 Full guide: [Open classic Teams in the background](https://scloud.work/en/teams-open-background/)

## Related

- [Run once at startup](https://github.com/FlorianSLZ/scloud/tree/main/run-once-at-startup) - the underlying pattern
- [New Teams client](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Microsoft%20Teams%20%28new%29) - deploy the new Teams client

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
