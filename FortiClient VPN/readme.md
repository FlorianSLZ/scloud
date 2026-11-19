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

# Deploy FortiClient VPN with a Preconfigured Profile via Microsoft Intune

> Win32 app that installs FortiClient VPN and imports a VPN configuration file with FCConfig through Microsoft Intune.

## Overview

The package installs the FortiClient VPN MSI silently and imports `FortiClientVPN.conf` (an exported VPN profile) with `FCConfig.exe`. The MSI itself is not part of this repository: download the FortiClient VPN-only installer from Fortinet, name it `FortiClientVPN.msi` and place it next to the scripts. It runs as an Intune Win32 app in the system context.

## What's included

| File | Description |
|------|-------------|
| `install.ps1` | Installs `FortiClientVPN.msi` silently, then runs `FCConfig.exe -m vpn -f FortiClientVPN.conf -o import -p <password>`. Set the config password in the script. |
| `uninstall.ps1` | Uninstalls the `FortiClient VPN` package. |
| `check.ps1` | Detection script: FortiClient version matches and the VPN tunnel profile exists in the registry. Set `$ProfileName` and `$ProgramVersion_target`. |
| `FortiClientVPN.conf` | Example VPN configuration export. |
| `FortiClient VPN.png` | App icon. |

## Usage

1. Add `FortiClientVPN.msi` and your own exported `FortiClientVPN.conf` to the folder.
2. Set the config password in `install.ps1` (`$ConfigPW`) and the profile name and target version in `check.ps1`.
3. Package the folder with the Win32 Content Prep Tool (setup file `install.ps1`).
4. Install command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\install.ps1`
5. Uninstall command: `%SystemRoot%\sysnative\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -executionpolicy bypass -command .\uninstall.ps1`
6. Detection rule: custom script, upload `check.ps1`.

## Blog post

📖 Full guide: [FortiClient VPN config with Intune](https://scloud.work/en/forticlient-vpn-config-intune/)

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
