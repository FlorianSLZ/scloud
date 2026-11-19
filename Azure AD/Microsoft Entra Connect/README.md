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

# Microsoft Entra Connect: Roll Over the Seamless SSO Kerberos Key

> PowerShell scripts to roll over the Kerberos decryption key for Seamless Single Sign-On in Microsoft Entra Connect, interactively or as a scheduled task.

## Overview

These scripts roll over the Kerberos decryption key of the `AZUREADSSOACC` computer account used for Seamless Single Sign-On in Microsoft Entra Connect (formerly Azure AD Connect). Microsoft recommends rolling this key over regularly. Run them on the Entra Connect server. One script is interactive, the other is built to run unattended as a scheduled task.

## What's included

| File | Description |
|------|-------------|
| `KerberosKey-RollOver.ps1` | Interactive: prompts for on-premises domain admin credentials, imports `AzureADSSO.psd1`, opens the authentication context and runs `Update-AzureADSSOForest` |
| `KerberosKey-RollOver_task.ps1` | Unattended variant for a scheduled task: reads a cloud admin and an on-premises user and their encrypted passwords from files, then runs `Update-AzureADSSOForest` |

## Usage

1. Sign in to the Entra Connect server (the scripts import `C:\Program Files\Microsoft Azure Active Directory Connect\AzureADSSO.psd1`).
2. Run `KerberosKey-RollOver.ps1`, enter the domain administrator credentials (`DOMAIN\USERNAME`) and sign in to Entra ID when prompted.
3. For automation, edit the user names and encrypted password file paths in `KerberosKey-RollOver_task.ps1` and run it from a scheduled task.

## Blog post

📖 More guides on the blog: [scloud.work](https://scloud.work/en/)

## Related

- [Azure AD](https://github.com/FlorianSLZ/scloud/tree/main/Azure%20AD) - Entra ID and managed identity scripts

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
