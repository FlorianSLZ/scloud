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

# Azure Automation with Managed Identity and Microsoft Graph

> PowerShell runbooks for Azure Automation that use a managed identity to authenticate to Microsoft Graph, manage its permissions and report stale Intune devices.

## Overview

Runbook scripts for Azure Automation that use a managed identity to call Microsoft Graph without storing credentials. They cover signing in with the managed identity, granting and removing Graph API permissions for it, and a sample runbook that finds inactive Intune devices and reports them to a Microsoft Teams webhook. Run the permission scripts interactively from an admin PowerShell session. Run the other scripts as runbooks in an Azure Automation account.

## What's included

| File | Description |
|------|-------------|
| `MgId_Authentificatin.ps1` | Runbook snippet: `Connect-AzAccount -Identity`, then connects to Microsoft Graph with an access token |
| `MgId_addPermissions.ps1` | Prompts for the managed identity name and assigns Graph app roles (the sample grants `DeviceManagementManagedDevices.Read.All`) |
| `MgId_removePermissions.ps1` | Prompts for the managed identity name and removes all of its app role assignments |
| `MgId_getOldDevices.ps1` | Runbook: lists Intune managed devices that have not synced for 180 days (adjustable) and posts the list to a Teams webhook URL |

## Usage

1. Create an Azure Automation account and enable a managed identity.
2. Run `MgId_addPermissions.ps1` in PowerShell, sign in to Microsoft Graph, and enter the name of your managed identity. Adjust the `$graphScopes` list to the permissions you need.
3. Import the runbook, for example `MgId_getOldDevices.ps1`, and set `$inactiveDays` and `$WebHookURL`.
4. Run or schedule the runbook. Use `MgId_removePermissions.ps1` to clean up the permissions later.

## Blog post

📖 Full guide: [Azure Automation with Managed Identities](https://scloud.work/en/azure-automation-managed-identities/)

## Related

- [Monitor-ExpiringEntraAppCreds](https://github.com/FlorianSLZ/scloud/tree/main/Automations/Monitor-ExpiringEntraAppCreds) - another Azure Automation runbook with a managed identity
- [Azure AD](https://github.com/FlorianSLZ/scloud/tree/main/Azure%20AD) - assign Graph permissions to a managed identity

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
