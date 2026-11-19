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

# Document Microsoft 365 Call Flows in Windows Sandbox

> Windows Sandbox setup that installs Microsoft Graph and Teams modules and runs the M365 Call Flow Visualizer to document auto attendants and call queues.

## Overview

A Windows Sandbox setup that documents Microsoft 365 Phone System call flows (auto attendants and call queues) as Mermaid diagrams. The sandbox installs the `Microsoft.Graph` and `MicrosoftTeams` modules and starts `M365CallFlowVisualizerV2.ps1`, so nothing is installed on your own PC. The visualizer script itself is by Martin Heusser (version 2.4.2 in this folder).

## What's included

| File | Description |
|------|-------------|
| `CallFlowDoku.wsb` | Sandbox config: maps this folder read-only and starts `CallFlowDoku.ps1` |
| `CallFlowDoku.ps1` | Installs `Microsoft.Graph` and `MicrosoftTeams`, then runs the visualizer |
| `M365CallFlowVisualizerV2.ps1` | Reads an auto attendant or call queue and writes the call flow as a Mermaid (`.mmd`) or Markdown (`.md`) file |

## Usage

1. Enable Windows Sandbox and adjust `HostFolder` in `CallFlowDoku.wsb` to the path of this folder.
2. Double-click `CallFlowDoku.wsb`.
3. Follow the prompts of the visualizer to select the auto attendant or call queue.

## Blog post

📖 Full guide: [Pre-installed PowerShell modules in Windows Sandbox](https://scloud.work/en/pre-installed-powershell-modules-in-windows-sandbox/)

## Related

- [Windows-Sandbox](https://github.com/FlorianSLZ/scloud/tree/main/Windows-Sandbox) - more sandbox templates

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
