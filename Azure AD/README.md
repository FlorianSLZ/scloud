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

# Assign Microsoft Graph Permissions to a Managed Identity (Entra ID)

> PowerShell script to assign Microsoft Graph application permissions to a managed identity in Microsoft Entra ID, plus Microsoft Entra Connect scripts.

## Overview

PowerShell snippets for Entra ID (formerly Azure AD). The script here assigns a Microsoft Graph application permission (app role) to a managed identity, which you cannot do in the Azure portal. The subfolder covers Microsoft Entra Connect.

## What's included

| File | Description |
|------|-------------|
| `managed-identiy_assig-permission.ps1` | Assigns a Graph app role (the sample uses `Sites.Manage.All`, alternative `Sites.Selected`) to a managed identity by its object ID, via `New-MgServicePrincipalAppRoleAssignment` |
| [`Microsoft Entra Connect`](Microsoft%20Entra%20Connect) | Scripts for the Kerberos key roll-over of Seamless SSO |

## Usage

1. Install the module: `Install-Module Microsoft.Graph`.
2. Set `$ObjectId` to the object (principal) ID of the managed identity and `$graphScope` to the permission you want to grant.
3. Run the script and sign in with an account allowed to consent (`AppRoleAssignment.ReadWrite.All`, `Application.Read.All`).

## Blog post

📖 Full guide: [Azure Automation with Managed Identities](https://scloud.work/en/azure-automation-managed-identities/)

## Related

- [Automations](https://github.com/FlorianSLZ/scloud/tree/main/Automations/AZ%20Automation%20with%20Managed%20Identity) - runbooks that use a managed identity

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
