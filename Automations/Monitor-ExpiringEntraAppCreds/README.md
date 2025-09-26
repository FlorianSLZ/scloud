<p align="center">
    <a href="https://scloud.work" alt="Florian Salzmann | scloud"></a>
            <img src="https://scloud.work/wp-content/uploads/2023/08/terminal-logo-scloud.webp" width="140" height="60" /></a>
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
    <a href="https://raw.githubusercontent.com/FlorianSLZ/EntraGroup.Toolbox/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/FlorianSLZ/EntraGroup.Toolbox.svg" />
    </a>

</p>

<p align="center">
    <a href='https://ko-fi.com/elflorian' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Glass of wine' /></a>
</p>

# Monitor-ExpiringEntraAppCreds

PowerShell scripts to monitor **Entra application credentials** (secrets and certificates) that are expired or expiring soon, and report them via email using Microsoft Graph.  
Designed for use in **Azure Automation runbooks** with a **Managed Identity**.

---

## Folder Structure

```
Monitor-ExpiringEntraAppCreds/
│
├── Monitor-ExpiringEntraAppCreds.ps1   # Main runbook script: collects expiring secrets/certs and emails a table
├── Add-ManagedIdenPermissions.ps1      # Helper script to grant required Graph application permissions to the Managed Identity
└── README.md                           # This file
```

---

## Monitor-ExpiringEntraAppCreds.ps1

### Features
- Connects to Microsoft Graph using **Managed Identity** (`Connect-MgGraph -Identity`).
- Retrieves all Entra applications.
- Detects **secrets and certificates** that are expired or expiring within a configurable window (default: 30 days).
- Sends a **formatted HTML email** with a table of findings (no CSV needed).
- Built for **PowerShell 5.1 & 7** in Azure Automation.

### Parameters
- `-To` → One or more recipient email addresses.  
- `-FromUserPrincipalName` → Mailbox used as sender (e.g. `reports@contoso.com`).  
- `-DaysAhead` → Look-ahead window for expiring credentials (default: 30).  
- `-SaveToSentItems` → Boolean, save email in Sent Items (default: `true`).  

### Example Run
```powershell
.\Monitor-ExpiringEntraAppCreds.ps1 `
  -To "itops@contoso.com","secops@contoso.com" `
  -FromUserPrincipalName "reports@contoso.com" `
  -DaysAhead 45
```

---

## Grant-MI-GraphPermissions.ps1

Helper script to grant the necessary Graph **application permissions** to the Runbook's Managed Identity.

### Permissions Assigned
- `Application.Read.All`  
- `Mail.Send`

### Usage
Run interactively with an account that has rights to assign app roles:
```powershell
.\Grant-MI-GraphPermissions.ps1
```
You'll be prompted for the **display name of your Managed Identity**.

---

## Requirements

- **Azure Automation account** with **System-Assigned Managed Identity** enabled.
- Microsoft.Graph.Authentication module imported into the Automation Account.
- Graph **Application permissions** (consented by an admin):
  - `Application.Read.All`
  - `Mail.Send`
- A valid mailbox for the `FromUserPrincipalName` parameter.



