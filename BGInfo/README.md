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

# Deploy BGInfo with a Custom Layout via PowerShell (Sysinternals)

> PowerShell script that downloads Sysinternals BGInfo, loads a custom .bgi layout and sets BGInfo to run at every logon.

## Overview

BGInfo shows system information such as hostname, IP address or logged-on user on the desktop background. `BGInfo-InstallSetup.ps1` creates `C:\Program Files\BgInfo`, downloads BGInfo from Sysinternals and the layout file `scloud.bgi` from this repository (saved as `logon.bgi`), adds an `HKLM\...\Run` entry for autostart and runs BGInfo once. Run it as administrator or as an Intune platform script in the system context.

## What's included

| File | Description |
|------|-------------|
| `BGInfo-InstallSetup.ps1` | Download, setup, autostart registry key and first run. |
| `scloud.bgi` | BGInfo layout file downloaded by the script. |

## Usage

1. Create your own layout in BGInfo, save it as `.bgi`, upload it to a location you control and change `$logonBgiUrl` in the script.
2. Run `BGInfo-InstallSetup.ps1` with administrator rights, or deploy it as an Intune platform script in the system context.
3. BGInfo then starts at every logon with `/timer:0 /nolicprompt`.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [DesktopInfo](https://github.com/FlorianSLZ/scloud/tree/main/DesktopInfo) - alternative: show the hostname on the desktop
- [Wallpaper and lock screen](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32/Wallaper%20%26%20Lockscreen) - set company wallpaper and lock screen

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
