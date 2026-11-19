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

# Monitor Expiring Entra App Secrets and Certificates (Azure Automation)

> An Azure Automation runbook that emails a report of expired and expiring Microsoft Entra application secrets and certificates using Microsoft Graph and a managed identity.

## Overview

Monitor-ExpiringEntraAppCreds is an Azure Automation runbook that reports Entra ID application credentials (client secrets and certificates) that are expired or about to expire. It uses a managed identity with Microsoft Graph and sends an HTML email with a summary table, with no SMTP or CSV file involved. A helper script grants the required Graph permissions to the managed identity. The runbook is written for PowerShell 5.1 and 7 in Azure Automation.

## What's included

| File | Description |
|------|-------------|
| `Monitor-ExpiringEntraAppCreds.ps1` | Main runbook: connects with `Connect-MgGraph -Identity`, checks all applications for expired or expiring secrets and certificates, and emails the result |
| `Grant-MI-GraphPermissions.ps1` | Helper: prompts for the managed identity name and assigns `Application.Read.All` and `Mail.Send` application permissions |

## Requirements

- Azure Automation account with a system-assigned managed identity
- `Microsoft.Graph.Authentication` module imported in the Automation account
- Graph application permissions with admin consent: `Application.Read.All` and `Mail.Send`
- A mailbox for the `-FromUserPrincipalName` parameter

## Usage

1. Run the helper once with an account that can assign app roles, and enter the name of your managed identity:

   ```powershell
   .\Grant-MI-GraphPermissions.ps1
   ```

2. Import `Monitor-ExpiringEntraAppCreds.ps1` as a runbook and schedule it.
3. Run it with the parameters below:

   ```powershell
   .\Monitor-ExpiringEntraAppCreds.ps1 `
     -To "itops@contoso.com","secops@contoso.com" `
     -FromUserPrincipalName "reports@contoso.com" `
     -DaysAhead 45
   ```

| Parameter | Description |
|-----------|-------------|
| `-To` | One or more recipient email addresses |
| `-FromUserPrincipalName` | Mailbox used as sender |
| `-DaysAhead` | Look-ahead window in days (default: 30) |
| `-SaveToSentItems` | Save the email in Sent Items (default: `true`) |

## Blog post

📖 Full guide: [Azure Automation with Managed Identities](https://scloud.work/en/azure-automation-managed-identities/)

## Related

- [AZ Automation with Managed Identity](https://github.com/FlorianSLZ/scloud/tree/main/Automations/AZ%20Automation%20with%20Managed%20Identity) - more runbooks with a managed identity

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
