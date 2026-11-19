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

# Block Device Code Flow with Conditional Access in Microsoft Entra ID

> Exported Conditional Access policy (JSON) that blocks device code authentication for all apps and users in Microsoft Entra ID to protect against device code phishing.

## Overview

Device code phishing tricks users into entering an attacker's code on the Microsoft sign-in page and hands the attacker a valid token. The policy **CA011 - All Apps: Block Device Code Auth For all Users** is a Microsoft Graph export (beta, `conditionalAccessPolicy`) of a Conditional Access policy in Microsoft Entra ID that blocks this authentication flow. Review it in report-only mode before enforcing it, since some device scenarios (for example some Teams Rooms or shared devices) rely on device code flow.

## What's included

| File | Description |
|------|-------------|
| `CA011 - All Apps Block Device Code Auth For all Users.json` | Policy export. Targets all users (one user object excluded) and all cloud apps, with the authentication flow `deviceCodeFlow` and grant control Block. Exported with state `enabled` and UTF-16 encoded. |

## Usage

1. Open the JSON and review the conditions (users, the excluded user ID, state).
2. Recreate the policy in **Entra admin center > Protection > Conditional Access**, or import the content through the Microsoft Graph API (`POST /identity/conditionalAccess/policies`) after removing the read-only fields such as `id` and the `@odata` annotations.
3. Exclude emergency access accounts, start in **report-only** mode, check the sign-in logs and then turn the policy on.

## Blog post

📖 Full guide: [Protecting against device code phishing attacks in Microsoft Entra ID](https://scloud.work/en/protecting-against-device-code-phishing-attacks-in-microsoft-entra-id/)

## Related

- [Compliance Policies](https://github.com/FlorianSLZ/scloud/tree/main/Compliance%20Policies) - custom compliance for Conditional Access grant controls

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
