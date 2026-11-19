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

# Enable Windows Hello with PowerShell and Intune

> A PowerShell script that enables Windows Hello for Business PIN sign-in on Windows devices via the registry, for deployment with Microsoft Intune.

## Overview

A small PowerShell script that enables Windows Hello for Business sign-in options on a device through the registry. It allows PIN logon for domain accounts, enables the `PassportForWork` policy and turns off post-logon provisioning. Deploy it as an Intune platform script in the system context when you want to prepare devices for Windows Hello.

## What's included

| File | Description |
|------|-------------|
| `Allow-WindowsHello.ps1` | Sets `AllowDomainPINLogon = 1` under `HKLM\SOFTWARE\Policies\Microsoft\Windows\System`, and `Enabled = 1` and `DisablePostLogonProvisioning = 1` under `HKLM\SOFTWARE\Policies\Microsoft\PassportForWork` |

## Usage

1. In Intune, add `Allow-WindowsHello.ps1` as a platform script and assign it to your devices.
2. Run it with administrator or system rights (it writes to `HKLM`).

## Blog post

📖 Full guide: [Windows Hello activated](https://scloud.work/en/windows-hello-aktiviert/)

## Related

- [Windows Hello for Business cloud trust](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Hello%20for%20Business%20cloud%20turst) - Intune profiles for hybrid cloud trust

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
