<p align="center">
    <a href="https://scloud.work" alt="Florian Salzmann | scloud"></a>
            <img src="https://scloud.work/wp-content/uploads/2023/08/terminal-logo-scloud.webp" height="75" /></a>
</p>
<p align="center">
    <a href="https://www.linkedin.com/in/fsalzmann/">
        <img alt="Made by" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361">
    </a>
    <a href="https://x.com/FlorianSLZ" alt="X / Twitter">
    	<img src="https://img.shields.io/twitter/follow/FlorianSLZ.svg?style=social"/>
    </a>
</p>

<p align="center">
    <a href="https://raw.githubusercontent.com/FlorianSLZ/scloud/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg" />
    </a>
    <a href="https://github.com/FlorianSLZ/scloud/graphs/contributors" alt="GitHub Contributors">
        <img src="https://img.shields.io/github/contributors/FlorianSLZ/scloud.svg"/>
    </a>
</p>

<p align="center">
    <a href='https://ko-fi.com/G2G211KJI9' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Glass of wine' /></a>
</p>

# Retry Failed Win32 Apps (Intune Remediation)

Intune's Global Re-evaluation Schedule (GRS) delays retrying failed Win32 app installations for up to 24 hours. This remediation package lets you bypass that wait and trigger an immediate retry, either on a schedule or on demand per device.

## What it does

- **Detection script** checks for failed Win32 app installation states in the IME registry
- **Remediation script** removes the relevant app and GRS registry keys, then restarts the Intune Management Extension service

This resets the retry counter so IME re-evaluates the app on the next sync.

## Usage

1. In Intune, go to **Devices > Scripts and remediations**
2. Create a new script package
3. Upload `RetryFailedApps_detection.ps1` as the detection script
4. Upload `RetryFailedApps_remediation.ps1` as the remediation script
5. Set **Run this script using the logged-on credentials** to **No** (runs as SYSTEM)
6. Set **Run script in 64-bit PowerShell host** to **Yes**

### On demand (recommended)

Leave the package unassigned. Trigger it per device via **Devices > select device > … > Run remediation (preview)**.

### Scheduled

Assign to a device group and set the schedule to run daily or hourly, depending on your needs.

## Requirements

- Windows Enterprise or Education (E3/E5 or A3/A5)
- Microsoft Entra joined or hybrid joined
- Intune Management Extension installed on the device
- For on-demand: device must be online and reachable via WNS

## Blog post

For the full explanation, background on GRS, and when (not) to use this:

🔗 [Retry Failed Win32 Apps on Demand with Intune Remediations](https://msnugget.com/retry-failed-win32-apps-on-demand-with-intune-remediations/)
