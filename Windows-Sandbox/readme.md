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

# Windows Sandbox Templates with PowerShell Modules for Microsoft 365 and Intune

> Windows Sandbox (.wsb) configurations that pre-install PowerShell modules and tools for Microsoft 365, Entra ID and Intune testing.

## Overview

Windows Sandbox configuration files (`.wsb`) with matching PowerShell scripts. Each one starts a clean, disposable Windows Sandbox that maps a folder from your host, installs the PowerShell modules you need and, where relevant, starts a script, so you can test Microsoft 365, Intune and Entra ID tooling without touching your own machine. Windows Sandbox must be enabled on the host.

## What's included

| File | Description |
|------|-------------|
| `PS-Modules.wsb` / `PS-Modules.ps1` | Installs `ExchangeOnlineManagement` and `MicrosoftTeams` |
| `HostMachine-Folder.wsb` / `HostMachine-Folder.ps1` | Maps `C:\GitHub\scloud` read/write and installs `MSOnline` and `AzureADPreview` |
| `M365Documentation.wsb` / `M365Documentation.ps1` | Installs `MSAL.PS`, `PSWriteWord` and `M365Documentation`, connects to the tenant and writes a Word document for Intune and Azure AD |
| `Intune-Test-Device.wsb` | Starts the MDM enrollment flow (`ms-device-enrollment`) in the sandbox to test an Intune enrollment |
| [`CallFlowDoku`](CallFlowDoku) | Documents Microsoft 365 Phone System call flows |
| [`win32-automated`](win32-automated) | Runs the automated Win32 app deployment script in the sandbox |

## Usage

1. Enable Windows Sandbox on the host.
2. Adjust the `HostFolder` path in the `.wsb` file (the files point to `C:\GitHub\scloud\...`).
3. Double-click the `.wsb` file. The sandbox opens and runs the PowerShell script from the mapped folder.

## Blog post

📖 Full guide: [Pre-installed PowerShell modules in Windows Sandbox](https://scloud.work/en/pre-installed-powershell-modules-in-windows-sandbox/)

## Related

- [CallFlowDoku](https://github.com/FlorianSLZ/scloud/tree/main/Windows-Sandbox/CallFlowDoku) - call flow documentation in a sandbox
- [win32-automated](https://github.com/FlorianSLZ/scloud/tree/main/Windows-Sandbox/win32-automated) - test Win32 app deployment in a sandbox

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
