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

# macOS Configuration Profiles for Intune: Chrome SSO and Platform SSO

> Microsoft Intune configuration profiles for macOS: Microsoft single sign-on in Google Chrome and Platform SSO with Entra ID.

## Overview

Configuration profiles for macOS devices managed with Microsoft Intune, focused on single sign-on with Microsoft Entra ID. One profile force-installs the Microsoft Single Sign On extension in Google Chrome, the other is an exported Settings Catalog policy for Platform SSO (PSSO).

## What's included

| File | Description |
|------|-------------|
| `macOS-GoogleChrome_MicrosoftSingleSignOn.mobileconfig` | Custom configuration profile "Chrome Extension Microsoft Single Sign On" that force-installs the Microsoft SSO extension in Google Chrome (`com.google.Chrome`) |
| `macOS-PSSO.json` | Exported Intune Settings Catalog policy "macOS-PSSO" (Platform SSO, extensible single sign-on for passwordless authentication) |

## Usage

1. For Chrome: in Intune, create a macOS custom profile and upload the `.mobileconfig` file, then assign it.
2. For Platform SSO: create the policy in the Settings Catalog (macOS) based on the values in `macOS-PSSO.json`, or import the JSON through the Graph API. Review the values for your tenant first.

## Blog post

📖 Full guides: [Entra join and Platform SSO for macOS with Intune](https://scloud.work/en/entra-join-platform-sso-for-macos-with-intune/) · [Google Chrome SSO with Entra ID on macOS](https://scloud.work/en/macos-google-chrome-single-sign-on-sso-entra-id/)

## Related

- [Mozilla Firefox](https://github.com/FlorianSLZ/scloud/tree/main/Mozilla%20Firefox) - Firefox single sign-on with Entra ID

---

**More from me:** [scloud.work](https://scloud.work/en/) · [LinkedIn - Florian Salzmann](https://www.linkedin.com/in/fsalzmann/) · [GitHub repo](https://github.com/FlorianSLZ/scloud)
