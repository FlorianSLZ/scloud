<p align="center">
    <a href="https://scloud.work" alt="Florian Salzmann | scloud"></a>
            <img src="https://scloud.work/wp-content/uploads/Intune-Diag.webp" width="75" height="75" /></a>
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
    <a href="https://www.powershellgallery.com/packages/Intune-Diag/" alt="PowerShell Gallery Version">
        <img src="https://img.shields.io/powershellgallery/v/Intune-Diag.svg" />
    </a>
    <a href="https://www.powershellgallery.com/packages/Intune-Diag/" alt="PS Gallery Downloads">
        <img src="https://img.shields.io/powershellgallery/dt/Intune-Diag.svg" />
    </a>
</p>
<p align="center">
    <a href="https://raw.githubusercontent.com/FlorianSLZ/scloud/master/LICENSE" alt="GitHub License">
        <img src="https://img.shields.io/github/license/FlorianSLZ/scloud.svg" />
    </a>
</p>

<p align="center">
	<a href='https://ko-fi.com/G2G211KJI9' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://storage.ko-fi.com/cdn/kofi1.png?v=3' border='0' alt='Buy Me a Coffee' /></a>
</p>

# Intune-Diag

**A simple PowerShell-based tool for analyzing Intune Management Extension logs and diagnostics.**  
Quickly troubleshoot Intune issues with an intuitive UI and built-in ZIP extraction.

## 🎯 Features
✅ **Easy-to-use UI** – Drag & Drop folders or ZIP files for instant analysis  
✅ **Local device analysis** – Run diagnostics on the current PC with one click  
✅ **ZIP extraction support** – Automatically extracts logs from compressed archives  
✅ **PowerShell-based** – Lightweight and efficient for IT Pros  
✅ **Intune-focused** – Designed specifically for troubleshooting Intune Management Extension (IME) based on the awesome **Get-IntuneManagementExtensionDiagnostics** from Petri Paavola

## 📥 Installation
Install Intune-Diag directly from the PowerShell Gallery:

```powershell
Install-Script Intune-Diag
```

Alternatively, you can download it manually:
```powershell
Save-Script Intune-Diag -Path C:\Tools
```

## 🚀 Usage
1. **Run the script**  
   ```powershell
   Intune-Diag.ps1
   ```
2. **Choose an analysis mode:**
    1. **Drag & Drop** a folder or ZIP file to analyze logs
        - Click **"Analyze Folder"** to start the analysis of the dropped folder.
    2. Click **"Analyze This PC"** to run diagnostics on the local device