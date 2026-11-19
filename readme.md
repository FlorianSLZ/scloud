<p align="center">
  <a href="https://scloud.work/en/" title="scloud.work - Intune & Microsoft blog by Florian Salzmann">
    <img src="https://scloud.work/images/logo/terminal-logo-scloud.webp" alt="scloud logo" height="75" />
  </a>
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/fsalzmann/"><img alt="Made by Florian Salzmann" src="https://img.shields.io/static/v1?label=made%20by&message=Florian%20Salzmann&color=04D361"></a>
  <a href="https://scloud.work/en/"><img alt="Blog scloud.work" src="https://img.shields.io/static/v1?label=blog&message=scloud.work&color=0A66C2"></a>
  <a href="https://x.com/FlorianSLZ"><img alt="X / Twitter" src="https://img.shields.io/twitter/follow/FlorianSLZ.svg?style=social"></a>
</p>

<p align="center">
  <a href="https://github.com/FlorianSLZ/scloud/blob/main/LICENSE"><img alt="GitHub License" src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg"></a>
  <a href="https://github.com/FlorianSLZ/scloud/graphs/contributors"><img alt="GitHub Contributors" src="https://img.shields.io/github/contributors/FlorianSLZ/scloud.svg"></a>
</p>

<p align="center">
  <a href="https://ko-fi.com/G2G211KJI9" target="_blank"><img height="36" style="border:0px;height:36px;" src="https://storage.ko-fi.com/cdn/kofi1.png?v=3" alt="Buy Me a Glass of Wine" /></a>
</p>

# Microsoft Intune Scripts, Win32 Apps & Remediations - [scloud.work](https://scloud.work/en/)

> A collection of PowerShell scripts, Intune Win32 app packages, Proactive Remediations, compliance policies and automation runbooks for Microsoft Intune, Entra ID, Windows Autopilot and Microsoft 365.

This repository is the companion to my blog [scloud.work](https://scloud.work/en/), where I write about Microsoft Intune and Microsoft technologies. Here you'll find the scripts and packages used in those blog posts, so you can reproduce the setups and explore the topics further. Every folder has its own README with a description, usage notes and a link to the matching blog post.

**Easy download:** open a folder, click the **ZIP file** (if one is provided) and use the download button.

## Repository overview

### Intune Win32 apps and packaging
| Folder | What you'll find |
|--------|------------------|
| [Program - win32](https://github.com/FlorianSLZ/scloud/tree/main/Program%20-%20win32) | Ready-to-use Win32 app packages (Dell Command Update, HP Image Assistant, Teams, Notepad++ with PSADT, ...) |
| [win32-template](https://github.com/FlorianSLZ/scloud/tree/main/win32-template) | Blank install / uninstall / detection template |
| [intune-win32-deployment](https://github.com/FlorianSLZ/scloud/tree/main/intune-win32-deployment) | Automated Win32 app upload to Intune |
| [winget](https://github.com/FlorianSLZ/scloud/tree/main/winget) | Windows Package Manager deployment and updates |
| [chocolatey](https://github.com/FlorianSLZ/scloud/tree/main/chocolatey) | Chocolatey installation, program template and updater |
| [DesktopInfo](https://github.com/FlorianSLZ/scloud/tree/main/DesktopInfo) | Show the hostname on the desktop |
| [DesktopShortcut](https://github.com/FlorianSLZ/scloud/tree/main/DesktopShortcut) | Desktop shortcuts from a CSV list |
| [Fonts](https://github.com/FlorianSLZ/scloud/tree/main/Fonts) | Install fonts with Intune |
| [FortiClient VPN](https://github.com/FlorianSLZ/scloud/tree/main/FortiClient%20VPN) | FortiClient VPN configuration |
| [Printers](https://github.com/FlorianSLZ/scloud/tree/main/Printers) | Shared printers and Point and Print |
| [RunAsRob](https://github.com/FlorianSLZ/scloud/tree/main/RunAsRob) / [RunAsSystem](https://github.com/FlorianSLZ/scloud/tree/main/RunAsSystem) / [MakeMeAdmin](https://github.com/FlorianSLZ/scloud/tree/main/MakeMeAdmin) | Part-time admin and system-context testing |
| [Taskbar Tool](https://github.com/FlorianSLZ/scloud/tree/main/Taskbar%20Tool) | Support tool that sends device info to Teams |
| [Teams](https://github.com/FlorianSLZ/scloud/tree/main/Teams) | Teams virtual backgrounds and background start |
| [Microsoft Apps](https://github.com/FlorianSLZ/scloud/tree/main/Microsoft%20Apps) | Outlook and Teams settings, Word template |
| [Excel template](https://github.com/FlorianSLZ/scloud/tree/main/Excel%20template) / [PowerPoint template](https://github.com/FlorianSLZ/scloud/tree/main/PowerPoint%20template) / [Normal mail template](https://github.com/FlorianSLZ/scloud/tree/main/Normal%20mail%20template) | Default Office templates |
| [Mozilla Firefox](https://github.com/FlorianSLZ/scloud/tree/main/Mozilla%20Firefox) | Firefox with the Windows certificate store |
| [run-once-at-startup](https://github.com/FlorianSLZ/scloud/tree/main/run-once-at-startup) | Run a script once at startup |
| [BGInfo](https://github.com/FlorianSLZ/scloud/tree/main/BGInfo) / [Support](https://github.com/FlorianSLZ/scloud/tree/main/Support) | BGInfo and OneDrive reinstall |

### Remediations, compliance and configuration
| Folder | What you'll find |
|--------|------------------|
| [Proactive Remediation](https://github.com/FlorianSLZ/scloud/tree/main/Proactive%20Remediation) | Detection and remediation script pairs for Intune |
| [Compliance Policies](https://github.com/FlorianSLZ/scloud/tree/main/Compliance%20Policies) | Custom compliance scripts and JSON |
| [Registry with Intune](https://github.com/FlorianSLZ/scloud/tree/main/Registry%20with%20Intune) | Set registry keys via Win32 app or remediation |
| [Conditional Access](https://github.com/FlorianSLZ/scloud/tree/main/Conditional%20Access) | Conditional Access policy examples |
| [Policies](https://github.com/FlorianSLZ/scloud/tree/main/Policies) | ADMX files and custom policies |
| [AppLocker](https://github.com/FlorianSLZ/scloud/tree/main/AppLocker) | AppLocker policy XMLs |
| [macOS](https://github.com/FlorianSLZ/scloud/tree/main/macOS) | macOS configuration profiles |
| [Windows Updates for Business](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Updates%20for%20Business) | Windows Update for Business snippets |

### Autopilot, identity and Windows features
| Folder | What you'll find |
|--------|------------------|
| [Windows Autopilot](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Autopilot) | Autopilot registration with an app registration |
| [Windows Hello](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Hello) / [Windows Hello for Business cloud turst](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20Hello%20for%20Business%20cloud%20turst) | Windows Hello and Hello for Business cloud trust |
| [Windows LAPS](https://github.com/FlorianSLZ/scloud/tree/main/Windows%20LAPS) | Windows LAPS configuration |
| [Azure AD](https://github.com/FlorianSLZ/scloud/tree/main/Azure%20AD) | Managed identity permissions, Kerberos key rollover |
| [Teams & Widgets](https://github.com/FlorianSLZ/scloud/tree/main/Teams%20%26%20Widgets) | Remove Chat and Widgets from the taskbar |
| [Windows-Sandbox](https://github.com/FlorianSLZ/scloud/tree/main/Windows-Sandbox) | Windows Sandbox configs for testing |
| [OSDCloud](https://github.com/FlorianSLZ/scloud/tree/main/OSDCloud) | OSDCloud image script |
| [BugFixes](https://github.com/FlorianSLZ/scloud/tree/main/BugFixes) | Fixes for common issues |

### Scripts, tools and automation
| Folder | What you'll find |
|--------|------------------|
| [scripts](https://github.com/FlorianSLZ/scloud/tree/main/scripts) | Intune-Diag, Start-SplashScreen, Set-GroupByPrimaryUser, Set-TimeZoneByIPAddress, Secure Boot certificate scripts and more |
| [Automations](https://github.com/FlorianSLZ/scloud/tree/main/Automations) | Azure Automation runbooks with managed identity |
| [Modules](https://github.com/FlorianSLZ/scloud/tree/main/Modules) | Intune environment JSON exports |
| [random-snipets](https://github.com/FlorianSLZ/scloud/tree/main/random-snipets) | Small useful snippets |

## About

I'm **Florian Salzmann**, working with Microsoft Intune, Entra ID and the Microsoft cloud. More guides, tools and deep dives are on the blog: **[scloud.work](https://scloud.work/en/)**. You can also connect with me on [LinkedIn](https://www.linkedin.com/in/fsalzmann/).

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
