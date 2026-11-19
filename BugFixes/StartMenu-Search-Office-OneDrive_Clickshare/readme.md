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

# Fix Start Menu, Search, Office Login and OneDrive Issues (Clickshare)

> Four PowerShell scripts that fix Windows Start menu, search, Office sign-in and OneDrive shell folder permission problems caused by Clickshare and broken app packages.

## Overview

Four numbered scripts that fix an unresponsive Start menu and search, Office sign-in issues and OneDrive problems on Windows, in a case where the Barco Clickshare client was involved. Run them in order, in the context given in the file name (`asUser` or `asAdmin`).

## What's included

| File | Description |
|------|-------------|
| `1_ClickShare-CalendarIntegration_asUser.ps1` | Stops `clickshare_native` and sets the Clickshare client registry values in HKCU to disable the calendar integration |
| `2_FixUserShellFolderPermissions_asUser.ps1` | Microsoft support helper that checks the ACLs of the `User Shell Folders` registry key, restores inheritance if "All Application Packages" is missing and registers app packages; run non-elevated in the affected user context |
| `3_StartMenuFIX_asAdmin.ps1` | Grants the "All Application Packages" group read access to the Explorer and `User Shell Folders` registry keys of the user profiles; run as administrator |
| `4_SearchFix_asUser.ps1` | Re-registers the Windows Search, Shell Experience Host, Cloud Experience Host, AAD Broker Plugin and related app packages with `Add-AppxPackage` |

## Usage

1. Run `1_ClickShare-CalendarIntegration_asUser.ps1` as the affected user.
2. Run `2_FixUserShellFolderPermissions_asUser.ps1` as the affected user (not elevated).
3. Run `3_StartMenuFIX_asAdmin.ps1` as administrator.
4. Run `4_SearchFix_asUser.ps1` as the affected user.

## Blog post

📖 Full guide: [Start menu not responding / Office login issue](https://scloud.work/en/start-menu-not-responding-office-login-issue/)

## Related

- [BugFixes](https://github.com/FlorianSLZ/scloud/tree/main/BugFixes) - more Windows fixes

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
