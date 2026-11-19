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

# Run a PowerShell Script Once at Startup with Intune (RunOnce Key or Scheduled Task)

> Two PowerShell templates that run your code exactly once at the next startup, using either a Registry RunOnce key or a scheduled task, for Microsoft Intune.

## Overview

Intune platform scripts and Win32 apps run at install time, but some changes only work after a restart or in a specific context. Both scripts save themselves locally, register a one-time trigger and run your code at the next startup. Put your code into the marked "code to run once" block.

## What's included

| File | Description |
|------|-------------|
| `run-once-at-startup_Registry.ps1` | Uses the `RunOnce` registry key (HKLM when run as SYSTEM, otherwise HKCU). |
| `run-once-at-startup_ScheduledTask.ps1` | Registers a SYSTEM scheduled task at startup that deletes itself and the script after running. |

## Usage

1. Insert your code between the `CODE TO RUN ONCE` markers.
2. Deploy the script as an Intune platform script or Win32 app. On the first run it registers the trigger; the code runs at the next startup.
3. Change `$Version` to run the code again on devices that already ran an earlier version.

## Blog post

📖 Full guide: [Run once at startup with Intune](https://scloud.work/en/run-once-at-startup-intune/)

## Related

- [Delete Teams cache once](https://github.com/FlorianSLZ/scloud/tree/main/Microsoft%20Apps/Teams) - example that uses the scheduled-task pattern
- [Teams open in background](https://github.com/FlorianSLZ/scloud/tree/main/Teams/Teams_open-in-background) - example that uses the RunOnce pattern

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
