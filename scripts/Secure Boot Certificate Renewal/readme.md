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

# Intune Secure Boot Certificate 2026 Monitoring

This repository contains the **Intune Detection and Remediation scripts** used to monitor the Microsoft **Secure Boot CA 2023 rollout** ahead of the **2026 certificate expiry**.

The solution focuses on:

- Detecting if the new **Windows UEFI CA 2023** certificate is already present
- Monitoring the **real Microsoft servicing status** via the Secure Boot registry
- Tracking rollout progress across an Intune-managed fleet
- Identifying devices that are blocked, failing, or still waiting for delivery via Windows Update

This project is designed for **monitoring and reporting only**. The actual certificate update is handled by Microsoft through Windows Update once the device is opted in.

---

## Full Technical Guide

The full step-by-step explanation, background, and implementation details are documented in my blog post:

👉  
https://scloud.work/intune-secure-boot-certificate-updates/

This README focuses on usage and structure only. For background, risks, and planning guidance, always refer to the blog post.
