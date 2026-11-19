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

# Lenovo Driver Updates with Intune Proactive Remediation (Draft)

> Work-in-progress Intune Proactive Remediation for Lenovo driver updates based on Lenovo System Update.

## Overview

This folder contains an early draft for updating Lenovo drivers through a Proactive Remediation in Microsoft Intune. The detection script starts Lenovo System Update (`tvsuShim.exe`) in list mode. Note that it is not finished: the result evaluation and the remediation script still reuse the HP Image Assistant logic from the [HP Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/HP%20Driver%20Updates) package, so adapt both before using them in production.

## What's included

| File | Description |
|------|-------------|
| `detection_LenovoUpdates.ps1` | Checks for `C:\Program Files (x86)\Lenovo\System Update\tvsuShim.exe` and runs a search with `/CM -search R -action LIST`. Evaluation of the result is still copied from the HP script. |
| `remediate_LenovoUpdates.ps1` | Currently identical to the HP remediation (HP Image Assistant). Needs to be rewritten for Lenovo System Update. |

## Usage

1. Install Lenovo System Update on the devices.
2. Replace the HPIA-based evaluation and remediation with Lenovo System Update commands and the log folder `C:\ProgramData\Lenovo\SystemUpdate\logs`.
3. Create a remediation package in **Devices > Scripts and remediations** and run it as SYSTEM in 64-bit PowerShell.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [HP Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/HP%20Driver%20Updates) - working HP Image Assistant version
- [DELL Driver Updates](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/DELL%20Driver%20Updates) - working Dell Command Update version
- [Lenovo Intelligent Sensing Service](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Lenovo%20Intelligent%20Sensing%20Service) - another Lenovo specific remediation

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
