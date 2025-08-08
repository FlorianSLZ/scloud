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
</p>

<p align="center">
    <a href='https://ko-fi.com/G2G211KJI9' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Glass of wine' /></a>
</p>

# Set Time Zone by IP Address (Intune Autopilot)

This PowerShell script automatically sets the correct Windows time zone during **Intune Autopilot** enrollment.  
It uses the free IPInfo legacy API to detect the device's IANA time zone and maps it to the correct Windows time zone format.  

No Azure Maps account or additional services are required.

## How it works
1. Retrieves the IANA time zone via `http://ipinfo.io/json`
2. Downloads the official Microsoft `windowsZones.xml` mapping
3. Converts the IANA time zone to the Windows time zone
4. Applies the time zone using `Set-TimeZone`

## Deployment
You can deploy the script via:
- **Intune platform script**  
- **Win32 app** for more control and logging  

For a complete step-by-step guide, see my blog post:  
[Automatically Set the Time Zone in Intune Autopilot without Azure Maps](https://scloud.work/automatically-set-the-time-zone-in-intune-autopilot)

---

**Note:** The IPInfo legacy API may be deprecated in the future, but at the time of writing, no end-of-life date is announced.
