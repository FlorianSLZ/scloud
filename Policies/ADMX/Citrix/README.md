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

# Citrix Workspace App ADMX for Microsoft Intune

> A custom ADMX/ADML template to manage the Citrix Workspace app with Microsoft Intune administrative templates.

## Overview

A custom ADMX/ADML template for the Citrix Workspace app (formerly Citrix Receiver) to use with Microsoft Intune custom ADMX import. It adds a "Citrix Components" policy category to manage the client, for example ICA file signing, generic USB remoting, StoreFront and NetScaler Gateway account lists, SSL and proxy settings and client selective trust.

## What's included

| File | Description |
|------|-------------|
| `Receiver-Intune.admx` | Policy definitions for the Citrix Workspace app client |
| `Receiver-Intune.adml` | English language resources |

## Usage

1. In the Intune admin center, go to Devices > Configuration > Import ADMX (Custom).
2. Upload `Receiver-Intune.admx` and `Receiver-Intune.adml` and wait until the status is "Available".
3. Create an Administrative Templates profile, configure the Citrix settings and assign it.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Drive Mapping ADMX](https://github.com/FlorianSLZ/scloud/tree/main/Policies/ADMX/DriveMapping) - another custom ADMX for Intune
- [Windows ADMX](https://github.com/FlorianSLZ/scloud/tree/main/Policies/ADMX/Windows) - fixes the Windows.admx namespace error

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
