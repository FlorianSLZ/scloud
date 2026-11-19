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

# Collect Log Files with Intune Proactive Remediation

> Intune Proactive Remediation that moves or copies application and PSADT log files into the Intune Management Extension log folder so you can collect them remotely.

## Overview

Logs written by Win32 apps, PSAppDeployToolkit or user-context scripts are spread over several folders and are hard to reach remotely. This detection/remediation pair gathers `.log` files from `C:\ProgramData\Logs\Software` and `C:\Users\*\AppData\Local\_MEM\Log` into `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs`. From there you can retrieve them with the Intune **Collect diagnostics** feature.

## What's included

| File | Description |
|------|-------------|
| `detection.ps1` | Searches the source folders for `*.log` files. Exit `1` and lists the files if any exist, otherwise exit `0`. |
| `remediation.ps1` | Moves (default) or copies the log files into the IME log folder. Switch behaviour with `$mode = "move"` or `"copy"`. |

## Usage

1. Adjust the `$Logs` source paths if your logs live elsewhere.
2. Create a remediation package in **Devices > Scripts and remediations**, run it as SYSTEM in 64-bit PowerShell.
3. Run it on demand or on a schedule, then use **Collect diagnostics** on the device.

## Blog post

📖 Full guide: [Collect diagnostics logs with Intune (custom)](https://scloud.work/en/collect-diagnostics-logs-intune-custom/)

## Related

- [Intune Diagnostic Tool](https://github.com/FlorianSLZ/scloud/tree/main/scripts/Intune-Diag) - collect and analyze Intune logs locally

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
