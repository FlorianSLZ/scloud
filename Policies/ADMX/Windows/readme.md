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

# Fix the Intune ADMX Import Error: Microsoft.Policies.Windows Namespace

> A Windows.admx and Windows.adml template that resolves the namespace missing error when importing custom ADMX files in Microsoft Intune.

## Overview

A Windows.admx and Windows.adml pair that fixes the Intune custom ADMX import error "Namespace 'Microsoft.Policies.Windows' is already defined" (the NamespaceMissing error). Other ADMX files that reference `Microsoft.Policies.Windows` can then be imported. The template uses the namespace `Microsoft.Policies.Windows` with the prefix `windows` and also references `Microsoft.Policies.Products`.

## What's included

| File | Description |
|------|-------------|
| `Windows.admx` | Policy definitions for the `Microsoft.Policies.Windows` namespace |
| `Windows.adml` | English language resources |

## Usage

1. In the Intune admin center, go to Devices > Configuration > Import ADMX (Custom).
2. Upload `Windows.admx` and `Windows.adml` first and wait until the status is "Available".
3. Then import the ADMX file that failed before.

## Blog post

📖 Full guide: [NamespaceMissing: Microsoft.Policies.Windows in Intune](https://scloud.work/en/namespacemissing-microsoft-policies-windows-intune/)

## Related

- [Drive Mapping ADMX](https://github.com/FlorianSLZ/scloud/tree/main/Policies/ADMX/DriveMapping) - custom ADMX for network drives

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
