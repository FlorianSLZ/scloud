<p align="center">
  <a href="https://scloud.work/en/" title="scloud.work - Intune & Microsoft blog by Florian Salzmann">
    <img src="https://scloud.work/images/logo/terminal-logo-scloud.webp" alt="scloud logo" height="75" />
  </a>
</p>

<p align="center">
  <img src="https://scloud.work/images/logo/Intune-Diag.webp" alt="Intune-Diag logo" width="75" height="75" />
</p>

<p align="center">
  <a href="https://www.powershellgallery.com/packages/Intune-Diag/"><img alt="PowerShell Gallery Version" src="https://img.shields.io/powershellgallery/v/Intune-Diag.svg"></a>
  <a href="https://www.powershellgallery.com/packages/Intune-Diag/"><img alt="PowerShell Gallery Downloads" src="https://img.shields.io/powershellgallery/dt/Intune-Diag.svg"></a>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/fsalzmann/"><img alt="Made by Florian Salzmann" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361"></a>
  <a href="https://scloud.work/en/"><img alt="Blog scloud.work" src="https://img.shields.io/static/v1?label=blog&message=scloud.work&color=0A66C2"></a>
  <a href="https://github.com/FlorianSLZ/scloud/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg"></a>
</p>

# Intune-Diag: Analyze Intune Management Extension and Autopilot Logs

> Intune-Diag is a PowerShell GUI tool that analyzes Microsoft Intune Management Extension (IME) and Windows Autopilot logs from a ZIP, a folder or the local device.

## Overview

Intune-Diag wraps well-known community diagnostic scripts in a simple UI so you can troubleshoot Microsoft Intune and Windows Autopilot issues without remembering command lines. Drag and drop a folder or ZIP with collected logs, or analyze the current PC with one click. The script downloads the selected diagnostic script from the PowerShell Gallery and runs it for you. It runs locally and is published on the PowerShell Gallery.

Supported diagnostic scripts, selectable in the UI:

- `Get-IntuneManagementExtensionDiagnostics` (by Petri Paavola)
- `Get-AutopilotDiagnostics` (by Michael Niehaus / Microsoft)
- `Get-AutopilotDiagnosticsCommunity` (by Andrew Taylor, Michael Niehaus and Steven van Beek)

Features:

- Drag and drop folders or ZIP files for instant analysis
- Local device analysis with one click ("Analyze This PC")
- Automatic extraction of logs from ZIP archives
- Script selector dropdown for multiple diagnostic tools (version 2.0)

## What's included

| File | Description |
|------|-------------|
| `Intune-Diag.ps1` | The PowerShell script with the UI (published to the PowerShell Gallery) |
| `LICENSE` | License of the tool |

## Usage

1. Install the script from the PowerShell Gallery:

   ```powershell
   Install-Script Intune-Diag
   ```

   Or download it without installing:

   ```powershell
   Save-Script Intune-Diag -Path C:\Tools
   ```

2. Run the script:

   ```powershell
   Intune-Diag.ps1
   ```

3. Choose an analysis mode:
   - Drag and drop a folder or ZIP file, then click **Analyze Folder**.
   - Or click **Analyze This PC** to run diagnostics on the local device.

## Blog post

📖 Full guide: [Intune Diagnostic Tool](https://scloud.work/en/intune-diagnostic-tool/)

## Related

- [Proactive Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) - detection and remediation scripts for Intune

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
