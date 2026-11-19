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

# AppLocker Policies for Microsoft Intune (XML Examples)

> Example AppLocker rule collections (EXE, DLL, MSI, Script, APPX) as XML for deployment with Microsoft Intune.

## Overview

Example AppLocker policies as XML, one file per rule collection, to apply with Microsoft Intune (for example via a custom OMA-URI profile for the AppLocker CSP). The `scloud_` files are my working policy and the `empty` folder holds the same files without rules as a clean starting point. EXE, MSI, script and packaged app (APPX) rules are enforced, and DLL rules are in audit-only mode. Review and adapt every rule to your environment, and test in audit mode before you enforce.

## What's included

| File | Description |
|------|-------------|
| `scloud_AppLocker_EXE.xml` | Executable rules (enforced), with path rules for the Windows and Program Files folders, all files for administrators and publisher rules |
| `scloud_AppLocker_DLL.xml` | DLL rules (audit only) |
| `scloud_AppLocker_MSI.xml` | Windows Installer rules (enforced) |
| `scloud_AppLocker_Script.xml` | Script rules (enforced) |
| `scloud_AppLocker_APPX.xml` | Packaged app rules (enforced) |
| `empty/empty_AppLocker_*.xml` | The same five collections without rules (EXE, DLL, MSI, Script, APPX) |

## Usage

1. Start with the `empty` files, or copy and adjust the `scloud_` files.
2. In Intune, create a custom profile for Windows 10 and later with an OMA-URI per collection, for example `./Vendor/MSFT/AppLocker/ApplicationLaunchRestrictions/EXEGroup/EXE/Policy`, and paste the XML as the value.
3. Assign the profile to a test group first and check the AppLocker event logs.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Deploy-IntuneEnv](https://github.com/FlorianSLZ/scloud/tree/main/Modules/Deploy-IntuneEnv) - baseline Intune policies including an AppLocker profile

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
