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

# Proactive Remediation for Business: Run Remediations without an Enterprise License

> Win32 app package that runs PowerShell detection and remediation scripts on a schedule through a scheduled task, for Microsoft 365 Business and other tenants without Intune remediation licensing.

## Easy download

To download this part of the repository, click on the **ZIP file** (`Proactive Remediation for Business.zip`) and use the download button.

## Overview

Proactive Remediations in Microsoft Intune require Windows Enterprise or Education licensing. This package gives Business tenants a comparable mechanism. It is deployed as a Win32 app and registers a scheduled task that runs your own `detection.ps1` on a schedule and, if it exits with `1`, runs `remediation.ps1`. The task is launched through a small VBScript so no PowerShell window pops up. It works in the system or user context. The included sample scripts remove desktop shortcuts named like `* - Copy.lnk`; replace them with your own logic.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Copies the scripts to `_MEM\Data\PR_PR4Business`, runs them once and registers the scheduled task. Schedule settings (`Once`, `Hourly`, `Daily`, `AtLogon`), interval and start time are defined at the top. |
| `uninstall.ps1` | Removes the scheduled task and the local script folder. |
| `check.ps1` | Win32 app detection script: succeeds if the scheduled task exists with the current `$Version`. |
| `detection.ps1` | Sample detection: finds `- Copy` shortcuts on user desktops (exit `1` = remediation needed). |
| `remediation.ps1` | Sample remediation: deletes those shortcuts. |
| `Proactive Remediation for Business.zip` | All files in one download. |

## Usage

1. Replace `detection.ps1` and `remediation.ps1` with your scripts and adjust `$PackageName`, `$Version` and the schedule variables in `install.ps1` (keep `$Version` identical in `check.ps1`).
2. Package the folder as `.intunewin` and create a Win32 app in Intune.
3. Install command: `powershell.exe -ExecutionPolicy Bypass -File install.ps1`
4. Uninstall command: `powershell.exe -ExecutionPolicy Bypass -File uninstall.ps1`
5. Detection rule: custom script `check.ps1`. Increase `$Version` in both files to roll out changes.

Logs are written to `%ProgramFiles%\_MEM\Log` (system) or `%LOCALAPPDATA%\_MEM\Log` (user).

## Blog post

📖 Full guide: [Proactive Remediation for Business](https://scloud.work/en/proactive-remediation-for-business/)

## Related

- [Proactive Remediation index](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - all remediations in this repository
- [OneDrive Desktop offline](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/OneDrive%20Desktop%20offline) - includes a Business Win32 variant

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
