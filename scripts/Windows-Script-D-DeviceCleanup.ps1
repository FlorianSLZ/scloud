<#
.SYNOPSIS
    Windows 11 post-deployment configuration script.

    Version 25H2, 2026-03-05


.DESCRIPTION
    Configures location services, time zone, Windows activation,
    Start Menu cleanup, taskbar layout, bloatware removal, and Intune log path rights.
    Converted from PSADT to plain PowerShell.
.NOTES
    Run this script as System/Device in 64 context.

#>

# ============================================================
# Configuration
# ============================================================

$ScriptName = "Windows-Script-D-DeviceCleanup"
$LogFile   = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\$ScriptName.log"

# Ensure log directory exists
New-Item -Path (Split-Path $LogFile) -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$timestamp] $Message"
    Write-Host $entry
    Add-Content -Path $LogFile -Value $entry -ErrorAction SilentlyContinue 
}

# ============================================================
# Apps to remove
# ============================================================

[array]$Apps2remove = @(
    "Clipchamp.Clipchamp"
    "Microsoft.BingNews"
    "Microsoft.BingWeather"
    "Microsoft.GamingApp"
    "Microsoft.GetHelp"
    "Microsoft.GetStarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.MixedReality.Portal"
    "Microsoft.MSPaint"
    "Microsoft.News"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.PowerAutomateDesktop"
    "Microsoft.Print3D"
    "Microsoft.SkypeApp"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.XboxApp"
    "Microsoft.YourPhone"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "MicrosoftCorporationII.MicrosoftFamily"
    "MicrosoftTeams"
    "MicrosoftWindows.Client.WebExperience"
    "MicrosoftWindows.CrossDevice"
    "9NHT9RB2F4HD"
)

# ============================================================
# Enable Location Services
# ============================================================

Write-Log "Enable location services so the time zone will be set automatically"

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' `
    -Name 'Value' -Value 'Allow' -Type String -Force

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' `
    -Name 'SensorPermissionState' -Value 1 -Type DWord -Force

Set-Service -Name 'lfsvc' -StartupType Automatic
Start-Service -Name 'lfsvc'

# ============================================================
# Time Service
# ============================================================

Write-Log "Time service --> automatic"

Set-TimeZone -Id "W. Europe Standard Time"
Set-Service -Name 'W32Time' -StartupType Automatic
Start-Service -Name 'W32Time'

# ============================================================
# Windows Activation (BIOS Key)
# ============================================================

Write-Log "Windows activation with BIOS Key"

try {
    $isVM = (Get-CimInstance -ClassName Win32_ComputerSystem).Model -like "*Virtual*"
    if ($isVM) {
        Write-Log "Virtual Machine detected. No BIOS Key activation."
    } else {
        $license = Get-CimInstance -ClassName SoftwareLicensingProduct |
            Where-Object { $_.Name -match 'windows' -and $_.PartialProductKey }

        if ($license.LicenseStatus -ne 1) {
            Write-Log "BIOS Key activation in progress"
            $biosKey = (Get-CimInstance -ClassName SoftwareLicensingService).OA3xOriginalProductKey

            if ($biosKey) {
                Write-Log "Found BIOS key: $biosKey"
                & cscript.exe "C:\Windows\System32\slmgr.vbs" /ipk $biosKey
                & cscript.exe "C:\Windows\System32\slmgr.vbs" /ato
                Write-Log "Activation completed successfully"
            } else {
                Write-Log "No BIOS key found."
            }
        } else {
            Write-Log "Windows is already activated."
        }
    }
} catch {
    Write-Log "Error during BIOS Key activation: $_"
}

# ============================================================
# Start Menu Cleanup (Start2.bin downloaded from GitHub)
# ============================================================

Write-Log "Start Menu Cleanup"

# TODO: Replace with your actual GitHub raw URL for Start2.bin
$start2Url  = "https://github.com/FlorianSLZ/scloud/raw/refs/heads/main/random-snipets/Start2.bin"
$start2Dest = 'C:\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState'
$start2File = Join-Path $start2Dest "Start2.bin"

try {
    New-Item -Path $start2Dest -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
    Write-Log "Downloading Start2.bin from GitHub"
    Invoke-WebRequest -Uri $start2Url -OutFile $start2File -UseBasicParsing
    Write-Log "Start2.bin downloaded successfully"
} catch {
    Write-Log "Failed to download Start2.bin: $_"
}

# ============================================================
# Taskbar Layout
# ============================================================

Write-Log "Importing Taskbar layout"

$taskbarXmlContent = @'
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer"/>
        <taskbar:DesktopApp DesktopApplicationID="MSEdge"/>
      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
 </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
'@

New-Item -ItemType Directory -Path "C:\Windows\OEM" -Force -ErrorAction SilentlyContinue | Out-Null
$taskbarXmlContent | Out-File -FilePath "C:\Windows\OEM\TaskbarLayoutModification.xml" -Encoding UTF8 -Force

& reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" `
    /v LayoutXMLPath /t REG_EXPAND_SZ /d "%SystemRoot%\OEM\TaskbarLayoutModification.xml" /f /reg:64 2>&1 | Out-Null

Write-Log "Unpin the Microsoft Store app from the taskbar"

# ============================================================
# Disable Edge Desktop Shortcut & Network Window
# ============================================================

$regSettings = @(
    @{ Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer';       Name = 'DisableEdgeDesktopShortcutCreation'; Value = 1; Type = 'DWord' }
    @{ Path = 'HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate';                   Name = 'CreateDesktopShortcutDefault';       Value = 0; Type = 'DWord' }
    @{ Path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Network';                 Name = 'NewNetworkWindowOff';                Value = 0; Type = 'DWord' }
    @{ Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'; Name = 'EnableFirstLogonAnimation';         Value = 0; Type = 'DWord' }
    @{ Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'; Name = 'DelayedDesktopSwitch';              Value = 0; Type = 'DWord' }
)

foreach ($reg in $regSettings) {
    if (-not (Test-Path $reg.Path)) {
        New-Item -Path $reg.Path -Force | Out-Null
    }
    Set-ItemProperty -Path $reg.Path -Name $reg.Name -Value $reg.Value -Type $reg.Type -Force
    Write-Log "Set registry: $($reg.Path)\$($reg.Name) = $($reg.Value)"
}

# ============================================================
# Remove Dev Home
# ============================================================

Write-Log "Disabling Windows 11 Dev Home"

$DevHome = 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate'
if (Test-Path $DevHome) {
    Write-Log "Removing DevHome key"
    Remove-Item -Path $DevHome -Recurse -Force -ErrorAction SilentlyContinue
}

# ============================================================
# Windows Bloat Removal
# ============================================================

Write-Log "Windows Bloat removal"

$provisionedApps = Get-AppxProvisionedPackage -Online

$Apps2remove | ForEach-Object {
    $current = $_
    $provisionedApps | Where-Object { $_.DisplayName -eq $current } | ForEach-Object {
        try {
            Write-Log "Removing provisioned app: $current"
            $_ | Remove-AppxProvisionedPackage -Online -AllUsers -ErrorAction SilentlyContinue | Out-Null
        } catch {
            Write-Log "Failed to remove $current : $_"
        }
    }
}

# ============================================================
# Intune Log Path Rights
# ============================================================

Write-Log "Intune Log Path rights"

$logPath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs"
Write-Log "Ensuring log path exists: $logPath"
New-Item -Path $logPath -ItemType Directory -Force | Out-Null

Write-Log "Setting Modify rights for Everyone on $logPath"
& "$([System.Environment]::SystemDirectory)\icacls.exe" `
    "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs" /grant "Everyone:(OI)(CI)M"

Write-Log "Script completed successfully"
