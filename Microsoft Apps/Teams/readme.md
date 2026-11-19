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

# Clear the Microsoft Teams Cache Once with Intune (PowerShell)

> PowerShell script that clears the Microsoft Teams cache for all users exactly once, using a scheduled task, for Microsoft Intune.

## Overview

`Delete-TeamsCache-once.ps1` registers a scheduled task that runs at the next startup as SYSTEM. The task stops Teams, deletes the cache folders (`application cache`, `blob storage`, `databases`, `GPUcache`, `IndexedDB`, `Local Storage`, `tmp`) in every user's `AppData\Roaming\Microsoft\Teams` folder, then removes the task and the script. Raise `$Version` to run it again.

## What's included

| File | Description |
|------|-------------|
| `Delete-TeamsCache-once.ps1` | Self-registering run-once script for the classic Teams cache cleanup. |

## Usage

1. Deploy the script as an Intune platform script (system context) or inside a Win32 app.
2. The first run saves a copy under `C:\ProgramData\Intune-Helper-Data` and registers the task. The cleanup runs at the next startup.
3. Logs are written to `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\clear-TeamsCache_run-once.log`.

## Blog post

📖 Full guide: [Clear the Teams cache once with Intune](https://scloud.work/en/microsoft-teams-cache-clear-once-intune/)

## Related

- [Run once at startup](https://github.com/FlorianSLZ/scloud/tree/main/run-once-at-startup) - the pattern used by this script
- [Teams open in background](https://github.com/FlorianSLZ/scloud/tree/main/Teams/Teams_open-in-background) - more Teams tweaks

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
