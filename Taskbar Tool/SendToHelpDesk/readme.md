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

# Send Support Info to Teams from a Taskbar Tool (Intune Win32 App)

> Win32 app that adds a systray tool to Windows which sends device information to a Microsoft Teams channel, deployed through Microsoft Intune.

## Overview

A systray menu (`HelpdeskInfo.ps1`) shows hostname and IP address and offers an action to send support information to a Microsoft Teams channel via incoming webhook. A scheduled task starts the tool at every logon. Users can send hostname, serial number, OS version, last update and uptime to the helpdesk with a click. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `HelpdeskInfo.ps1` | Systray icon with menu: hostname, IP address, *Send Support info*, *Exit*. |
| `Actions/SendToHelpdesk_Teams.ps1` | Collects device data and posts it to a Teams webhook. Set `$WebHookURL`. |
| `icons/` | Menu and tray icons. |
| `install.ps1` | Copies the files to `C:\ProgramData\Helpdesk Info` and registers the logon task `HelpdeskInfo` for the Users group. |
| `uninstall.ps1` | Removes the task and the folder. |
| `check.ps1` | Detection script: task exists with the right version. |
| `install.intunewin` | Ready-to-upload Intune package. |

**Easy download:** click on the ZIP file (`SendToHelpDesk.zip`) and use the download button.

## Usage

1. Create an incoming webhook (or Workflows webhook) in your Teams channel and enter the URL in `Actions\SendToHelpdesk_Teams.ps1`.
2. Create a new **Windows app (Win32)** in Microsoft Intune and upload the `.intunewin` file.
3. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
4. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
5. Detection rule: custom script, upload `check.ps1`. It writes `Found it!` to the output when the package is detected.

## Blog post

📖 Full guide: [Send support information to a Teams channel](https://scloud.work/en/send-support-information-to-teams-channel/)

## Related

- [Support Tool](https://github.com/FlorianSLZ/scloud/tree/main/Taskbar%20Tool/Support%20Tool) - same tool plus a TeamViewer QuickSupport action

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
