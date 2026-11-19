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

# Test Automated Win32 App Deployment for Intune in Windows Sandbox

> A Windows Sandbox configuration that runs the automated Intune Win32 app deployment script in an isolated, disposable environment.

## Overview

A Windows Sandbox setup to test the automated Win32 app deployment script for Microsoft Intune in an isolated environment. The sandbox installs the `IntuneWin32App` and `Microsoft.Graph.Intune` modules and then runs `intune-win32-deployment.ps1` from the `_UploadWin32App` folder of the `intune-win32-deployment` repo folder, which is mapped read/write.

## What's included

| File | Description |
|------|-------------|
| `win32-automated.wsb` | Sandbox config: maps this folder (read-only) and the `intune-win32-deployment` folder (read/write), then starts the script |
| `win32-automated.ps1` | Installs the required modules and calls `intune-win32-deployment.ps1` |

## Usage

1. Enable Windows Sandbox and adjust both `HostFolder` paths in `win32-automated.wsb` to your local clone.
2. Double-click `win32-automated.wsb`.
3. Follow the prompts of the deployment script inside the sandbox.

## Blog post

📖 Full guide: [Win32 app deployment, automated](https://scloud.work/en/win32-app-deployment-automated/)

## Related

- [intune-win32-deployment](https://github.com/FlorianSLZ/scloud/tree/main/intune-win32-deployment) - the automated Win32 app upload script
- [Windows-Sandbox](https://github.com/FlorianSLZ/scloud/tree/main/Windows-Sandbox) - more sandbox templates

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
