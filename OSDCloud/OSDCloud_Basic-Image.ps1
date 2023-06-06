# Install deployment tools: https://go.microsoft.com/fwlink/?linkid=2120254
# Install WinPE add-on for Windows ADK: https://go.microsoft.com/fwlink/?linkid=2120253
# Install Module: Install-Module OSD -Force

# German/Swiss Template
New-OSDCloudTemplate -Language de-de -SetInputLocale de-CH -Verbose

# Set Workshpace Folder
$WorkingDir = "$ENV:TEMP\OSDCloud"
New-Item -ItemType Directory $WorkingDir
Set-OSDCloudWorkspace -WorkspacePath $WorkingDir


$Startnet = @'
start /wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
start /wait PowerShell -NoL -C Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Pro -OSLanguage de-de -OSLicense Retail
'@
Edit-OSDCloudWinPE -Startnet $Startnet -StartOSDCloudGUI -Brand 'OSD by el Florian' -Wallpaper "C:\Users\florian.salzmann\OneDrive - scloud\Bilder\Wallpapers\wallpaper-salzmannpro.jpg" -CloudDriver *


# create OSD ISO
New-OSDCloudISO -WorkspacePath $WorkingDir

Write-Host "Neues ISO unter: $WorkingDir" 


<# 
#Uninstall
Get-Module -ListAvailable -Name OSD
Remove-Module OSD
Uninstall-Module OSD -AllVersions -Force -Verbose
#>

Edit-OSDCloudWinPE -StartOSDCloudGUI -Brand 'OSD by el Florian' -Wallpaper "C:\Users\florian.salzmann\OneDrive - scloud\Bilder\Wallpapers\wallpaper-salzmannpro.jpg" -CloudDriver *
