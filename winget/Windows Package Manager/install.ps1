$PackageName = "winget"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

# Program/Installation folder
$Folder_install = "$env:temp\winget-installation"
New-Item -Path $Folder_install -ItemType Directory -Force -Confirm:$false
Set-Location $Folder_install

$progressPreference = 'silentlyContinue'

# Download
Write-Host "Downloading WinGet..."
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Write-Host "Downloading VCLibs..."
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Write-Host "Downloading UI.Xaml..."
Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx

# Installation
Write-Host "Installing VCLibs..."
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Write-Host "Installing UI.Xaml..."
Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
Write-Host "Installing WinGet..."
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

Stop-Transcript
