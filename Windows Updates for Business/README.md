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

# Windows Update for Business with Microsoft Graph PowerShell

> Microsoft Graph PowerShell snippets to enroll devices in Windows Update for Business, list the update catalog and manage deployments.

## Overview

A collection of Microsoft Graph PowerShell snippets for the Windows Update for Business (WUfB) deployment service. They show how to check device readiness, enroll devices for feature updates, list the update catalog and review deployments. The file is a snippet collection to run step by step, not one script to run top to bottom.

## What's included

| File | Description |
|------|-------------|
| `WUfB-CodeSnippeds.ps1` | Snippets to install `Microsoft.Graph`, connect with the `WindowsUpdates.ReadWrite.All`, `User.Read.All`, `Device.Read.All` and `Group.Read.All` scopes, check device readiness, enroll a device for feature updates, list feature and quality update catalog entries, and list deployments |

## Usage

1. Install the Microsoft Graph module and connect to Graph with the scopes from the file.
2. Run the snippets section by section, for example `Get-MgWuUpdatableAsset` to check a device and `Invoke-MgEnrollWindowsUpdatesUpdatableAsset` to enroll it.
3. Adjust the snippets to your devices and groups.

## Blog post

📖 Full guide: [Windows Updates for Business](https://scloud.work/en/windows-updates-for-business/)

## Related

- [random-snipets](https://github.com/FlorianSLZ/scloud/tree/main/random-snipets) - registry files to pin the Windows 11 feature update version

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
