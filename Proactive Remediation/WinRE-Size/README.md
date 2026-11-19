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

# Extend the WinRE Recovery Partition with Intune Proactive Remediation

> Intune Proactive Remediation that checks free space on the Windows Recovery (WinRE) partition and recreates it larger when less than 500 MB is free.

## Overview

Too small a recovery partition blocks Windows updates that need to modify the WinRE image and can cause problems with features like BitLocker. The detection script verifies that the recovery partition on the system disk has more than 500 MB free. The remediation disables WinRE, shrinks the preceding partition, recreates the recovery partition with `diskpart` (GPT or MBR layout) and re-enables WinRE.

## What's included

| File | Description |
|------|-------------|
| `WinRE-Size_Detection.ps1` | Exit `0` if more than 500 MB free, `1` if less. Special exit codes: `1000` system drive not found, `2000` recovery partition not found, `3000` unexpected error. |
| `WinRE-Size_Remediation.ps1` | Resizes partitions and rebuilds the recovery partition (`$freePartitionSpace = "500MB"`). Exit `0` on success, `2000` on error. |

## Usage

1. Test on a non-production device first, because the remediation changes the disk layout. Make sure there is a backup.
2. Create a remediation package in **Devices > Scripts and remediations** and run it as SYSTEM in 64-bit PowerShell.
3. Assign it to a pilot group, review the output in the remediation report and then extend the rollout.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Free up disk space with Intune Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation/Free%20up%20disk%20space%20with%20Intune%20Remediation) - prepare devices for Windows 11 upgrades

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
