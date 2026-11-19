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

# Set the Time Zone by IP Address in Intune Autopilot

> A PowerShell script that automatically sets the Windows time zone from the public IP address during Microsoft Intune Autopilot enrollment, without Azure Maps.

## Overview

This PowerShell script sets the correct Windows time zone during Microsoft Intune Autopilot enrollment, based on the device's public IP address. It queries the free IPInfo legacy API for the IANA time zone and maps it to the Windows time zone. No Azure Maps account or other service is required. It must run as SYSTEM in a 64-bit context, as an Intune platform script or as a Win32 app.

How it works:

1. Gets the IANA time zone from `http://ipinfo.io/json`.
2. Downloads the `windowsZones.xml` mapping from this folder.
3. Converts the IANA time zone to the Windows time zone.
4. Applies it with `Set-TimeZone`.

## What's included

| File | Description |
|------|-------------|
| `Set-TimeZoneByIPAddress.ps1` | Detects the time zone via IP and sets it; logs to the Intune Management Extension log folder |
| `windowsZones.xml` | IANA to Windows time zone mapping used by the script |

## Usage

1. Deploy `Set-TimeZoneByIPAddress.ps1` as an Intune platform script, or package it as a Win32 app for more control and logging.
2. Run it in the system context (not the user context) and in a 64-bit PowerShell.
3. Check the log at `C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Set-TimeZoneByIPAddress-script.log`.

Note: the IPInfo legacy API may be deprecated in the future. At the time of writing, no end-of-life date was announced.

## Blog post

📖 Full guide: [Automatically set the time zone in Intune Autopilot](https://scloud.work/en/automatically-set-the-time-zone-in-intune-autopilot/)

## Related

- [Windows Autopilot](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Autopilot) - more Autopilot helper scripts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
