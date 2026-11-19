<p align="center">
  <a href="https://scloud.work/en/" title="scloud.work - Intune & Microsoft blog by Florian Salzmann">
    <img src="https://scloud.work/images/logo/terminal-logo-scloud.webp" alt="scloud logo" height="75" />
  </a>
</p>

<p align="center">
  <img src="https://scloud.work/images/logo/Start-SplashScreen.webp" alt="Start-SplashScreen logo" width="75" height="75" />
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/Start-SplashScreen/"><img alt="PowerShell Gallery Version" src="https://img.shields.io/powershellgallery/v/Start-SplashScreen.svg"></a>
  <a href="https://www.powershellgallery.com/packages/Start-SplashScreen/"><img alt="PowerShell Gallery Downloads" src="https://img.shields.io/powershellgallery/dt/Start-SplashScreen.svg"></a>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/fsalzmann/"><img alt="Made by Florian Salzmann" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361"></a>
  <a href="https://scloud.work/en/"><img alt="Blog scloud.work" src="https://img.shields.io/static/v1?label=blog&message=scloud.work&color=0A66C2"></a>
  <a href="https://github.com/FlorianSLZ/scloud/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg"></a>
</p>

# Start-SplashScreen: PowerShell Splash Screen for Windows Autopilot and OOBE

> Start-SplashScreen is a PowerShell script that shows a progress splash screen while scripts run during Windows deployment, Autopilot or Intune provisioning.

## Overview

Start-SplashScreen shows a graphical splash screen while a list of scripts or commands runs, for example during Windows Autopilot, OOBE or OSDCloud deployments. It displays a header, the name of the running step, a status indicator and an optional countdown before it closes. Buttons let you show or hide the underlying PowerShell console for troubleshooting. It is a PowerShell script published on the PowerShell Gallery.

Features:

- Customizable title, messages, colors and optional logo (`-LogoURL`)
- Runs a list of PowerShell commands or script URLs (http, https, ftp) and reports progress
- Show/hide button for the PowerShell console
- Countdown before the window closes automatically

## What's included

| File | Description |
|------|-------------|
| `Start-SplashScreen.ps1` | The splash screen script (published to the PowerShell Gallery) |
| `LICENSE` | License of the tool |

## Requirements

- Windows
- PowerShell 5.1 or later

## Usage

Install the script from the PowerShell Gallery:

```powershell
Install-Script -Name Start-SplashScreen
```

Define the steps to run and start the splash screen:

```powershell
$ProcessesArray = @(
    @{ Name = "Process 1"; Script = "Start-Service MyService" },
    @{ Name = "Process 2"; Script = "https://example.com/script.ps1" }
)

.\Start-SplashScreen.ps1 -Processes $ProcessesArray -MessageHeader "Setup in Progress" -MessageFinished "Installation Complete!" -ClosingTimer 10
```

The splash screen shows the header "Setup in Progress" while it runs both steps and closes 10 seconds after they finish.

### Parameters

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| `-Processes` | Yes | - | Array of steps, each with a `Name` and a `Script` (command or URL) |
| `-MessageHeader` | No | `Windows Preparation` | Main message |
| `-MessageText` | No | `Initiate Installation` | Initial message where the step names appear |
| `-MessageStatus` | No | `...` | Initial status indicator |
| `-MessageFinished` | No | `All processes finished. This window closes automatically.` | Message shown before closing |
| `-ClosingTimer` | No | `5` | Seconds until the window closes after finishing |
| `-ColorBackground` | No | `#f4f4f4` | Background color, e.g. `#CCf4f4f4` for 80% transparency |
| `-ColorText` | No | `#161616` | Text color |
| `-LogoURL` | No | empty | Optional logo URL |

## Blog post

📖 Full guide: [Splash Screen for Windows with Start-SplashScreen](https://scloud.work/en/splash-screen-for-windows-start-splashscreen/)

## Related

- [OSDCloud](https://github.com/FlorianSLZ/scloud/tree/main/OSDCloud) - Windows deployment with OSDCloud
- [Windows Autopilot](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Autopilot) - Autopilot registration and helper scripts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
