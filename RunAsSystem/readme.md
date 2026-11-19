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

# Test Intune Win32 Apps in the SYSTEM Context with PsExec

> Helper scripts that open a PowerShell window as NT AUTHORITY\SYSTEM with PsExec to test Intune Win32 app installs the way Intune runs them.

## Overview

Intune installs Win32 apps in the system context, which behaves differently from a local admin session. `PS_as_System.ps1` self-elevates, downloads PSTools from Sysinternals, accepts the EULA and starts `powershell.exe` as SYSTEM with `psexec -i -s`. `runassystem.cmd` does the same with the bundled `PsExec.exe`.

## What's included

| File | Description |
|------|-------------|
| `PS_as_System.ps1` | Self-elevating script that downloads PSTools and opens a PowerShell window as SYSTEM. |
| `runassystem.cmd` | Starts `psexec.exe -i -s powershell.exe` (adjust the `cd` path first). |
| `PsExec.exe` | Sysinternals PsExec. |

**Easy download:** click on the ZIP file (`RunAsSystem.zip`) and use the download button.

## Usage

1. Run `PS_as_System.ps1` (approve the UAC prompt). A PowerShell window opens as SYSTEM.
2. In that window, change to your package folder and run `.\install.ps1` to test the installation exactly as Intune would.
3. Check with `whoami` that you are `nt authority\system`.

## Blog post

📖 Full guide: [Testing applications in the SYSTEM context with PsExec](https://scloud.work/en/testing-applications-system-context-psexec/)

## Related

- [Win32 template](https://github.com/FlorianSLZ/scloud/tree/main/win32-template) - start a new Win32 app from a template

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
