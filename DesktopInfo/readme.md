<p align="center">
    <a href="https://scloud.work" alt="Florian Salzmann | scloud"></a>
            <img src="https://scloud.work/images/logo/terminal-logo-scloud.webp" height="75" /></a>
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
    <a href='https://ko-fi.com/G2G211KJI9' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Glass of wine' /></a>
</p>

# DesktopInfo Intune Package

This repository contains all necessary files to deploy [DesktopInfo](https://www.glenn.delahoy.com/desktopinfo/) via Microsoft Intune as a Win32 application.

With this setup, you can automatically show the device name directly on the user's desktop – especially useful for support scenarios and environments without physical labels.

## 📦 Quick Download

For convenience, all required files are bundled in `DesktopInfo.zip` – ready to use or modify for your own Intune deployment.

## Included Files

- `install.ps1` – Installs DesktopInfo, sets up a scheduled task and config file
- `uninstall.ps1` – Removes the scheduled task and program files
- `DesktopInfo.exe` – The main application
- `DesktopInfo.ps1` – Launch script
- `hostname.ini` – Configuration file (shows PC name on screen)
- `DesktopInfo.png` – Optional icon or screenshot for Intune

## 📖 Full Documentation & Blogpost

All steps including configuration and deployment via Intune are explained in detail in this blog post:  
👉 [https://scloud.work/hostname-auf-desktop/](https://scloud.work/hostname-auf-desktop/)


