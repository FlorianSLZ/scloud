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

# Make Firefox Use the Windows Certificate Store with Intune (PowerShell)

> PowerShell script that configures Mozilla Firefox to trust root certificates from the Windows certificate store, deployable with Microsoft Intune.

## Overview

`Firefox_WindowsCertificateStore.ps1` writes `local-settings.js` and a custom `scloud.cfg` into the Firefox installation folder. The config locks `security.enterprise_roots.enabled` to `true`, so Firefox accepts certificates your devices already trust, for example from an internal CA or SCEP/PKCS deployment via Intune.

## What's included

| File | Description |
|------|-------------|
| `Firefox_WindowsCertificateStore.ps1` | Creates `defaults\pref\local-settings.js` and `scloud.cfg` in `C:\Program Files\Mozilla Firefox` with `lockPref("security.enterprise_roots.enabled", true)`. |

## Usage

1. Deploy the script as an Intune platform script in the system context (Firefox must be installed to `C:\Program Files\Mozilla Firefox`), or wrap it in a Win32 app.
2. Restart Firefox on the devices. Logs are written to `C:\Program Files\_MEM\Log\`.

## Blog post

📖 Full guide: [Use the Windows certificate store in Firefox with Intune](https://scloud.work/en/firefox-use-windows-certificate-store-intune/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
