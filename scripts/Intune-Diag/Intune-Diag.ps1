<#PSScriptInfo

.VERSION 2.0
.GUID b00d1997-e4fa-4af1-86f0-49220c606238
.AUTHOR Florian Salzmann
.COMPANYNAME scloud.work
.COPYRIGHT 2025 Florian Salzmann. GPL-3.0 license.
.TAGS PowerShell Intune Diagnostics LogAnalyzer Autopilot
.LICENSEURI https://github.com/FlorianSLZ/scloud/blob/main/LICENSE
.PROJECTURI https://github.com/FlorianSLZ/scloud/tree/main/scripts/Intune-Diag
.ICONURI https://scloud.work/wp-content/uploads/Intune-Diag.png
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
    2024-09-26, 1.0:    Original published version.
    2025-03-14, 1.1:    Minor improvements
    2025-03-14, 1.2:    Changed to English, improved Errorhandling and loader, Added button for local analysis
    2026-02-24, 2.0:    UI overhaul, added script selector dropdown for multiple diagnostic tools
                         (IME Diagnostics, Autopilot Diagnostics, Autopilot Diagnostics Community)

#> 

<# 

.DESCRIPTION 
A PowerShell-based tool for analyzing Intune Management Extension and Autopilot logs.
Quickly troubleshoot Intune and Autopilot issues with an intuitive UI and built-in ZIP extraction.

Supported diagnostic scripts (downloaded from PowerShell Gallery):
- Get-IntuneManagementExtensionDiagnostics (by Petri Paavola)
- Get-AutopilotDiagnostics (by Michael Niehaus / Microsoft)
- Get-AutopilotDiagnosticsCommunity (by Andrew Taylor, Michael Niehaus & Steven van Beek)

#> 

#########################################################################################
# Initial Setup
#########################################################################################
$PackageName = "IntuneDiagnostic-UI"
$ScriptFolder = "C:\ProgramData\$PackageName"

# Script definitions: Name, display label, script file name, and how to pass folder/file args
$DiagScripts = @(
    @{
        Name        = "Get-IntuneManagementExtensionDiagnostics"
        Label       = "IME Diagnostics (Petri Paavola)"
        FileName    = "Get-IntuneManagementExtensionDiagnostics.ps1"
        FolderArg   = '-LogFilesFolder "{0}"'     # accepts folder path
        FileArg     = '-LogFilesFolder "{0}"'     # ZIP extracted to folder
        LocalArg    = ''                          # no args = local
    },
    @{
        Name        = "Get-AutopilotDiagnostics"
        Label       = "Autopilot Diagnostics (Michael Niehaus)"
        FileName    = "Get-AutopilotDiagnostics.ps1"
        FolderArg   = '-ZIPFile "{0}"'            # accepts ZIP/CAB file
        FileArg     = '-ZIPFile "{0}"'            # pass ZIP directly
        LocalArg    = ''                          # no args = local
    },
    @{
        Name        = "Get-AutopilotDiagnosticsCommunity"
        Label       = "Autopilot Diagnostics Community (Andrew Taylor)"
        FileName    = "Get-AutopilotDiagnosticsCommunity.ps1"
        FolderArg   = '-File "{0}"'               # accepts ZIP/CAB file
        FileArg     = '-File "{0}"'               # pass ZIP directly
        LocalArg    = ''                          # no args = local
    }
)

#########################################################################################
# Execution Policy Check
#########################################################################################
$CurrentPolicy = Get-ExecutionPolicy -Scope Process
if ($CurrentPolicy -ne "Bypass") {
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
}

#########################################################################################
# Download Scripts
#########################################################################################
if (!(Test-Path $ScriptFolder)) {
    New-Item -Path $ScriptFolder -Type Directory -Force | Out-Null
}

foreach ($ds in $DiagScripts) {
    $scriptPath = Join-Path $ScriptFolder $ds.FileName
    if (!(Test-Path $scriptPath)) {
        try {
            Save-Script $ds.Name -Path $ScriptFolder -Force -ErrorAction Stop
        } catch {
            Write-Host "Warning: Could not download $($ds.Name): $_" -ForegroundColor Yellow
        }
    }
}

#########################################################################################
# UI
#########################################################################################
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set unique AppUserModelID so the taskbar shows our icon instead of the PowerShell icon
try {
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class TaskbarHelper {
    [DllImport("shell32.dll", SetLastError = true)]
    public static extern void SetCurrentProcessExplicitAppUserModelID(
        [MarshalAs(UnmanagedType.LPWStr)] string AppID);
}
"@
    [TaskbarHelper]::SetCurrentProcessExplicitAppUserModelID("scloud.IntuneDiagnosticTool")
} catch {
    # Silently ignore on older systems
}

# ---------- Color Palette ----------
$colBg          = [System.Drawing.Color]::FromArgb(30, 30, 30)
$colSurface     = [System.Drawing.Color]::FromArgb(45, 45, 48)
$colAccent      = [System.Drawing.Color]::FromArgb(0, 120, 212)       # Microsoft blue
$colAccentHover = [System.Drawing.Color]::FromArgb(16, 138, 230)
$colSuccess     = [System.Drawing.Color]::FromArgb(16, 185, 129)
$colWarning     = [System.Drawing.Color]::FromArgb(245, 158, 11)
$colError       = [System.Drawing.Color]::FromArgb(239, 68, 68)
$colTextPrimary = [System.Drawing.Color]::White
$colTextMuted   = [System.Drawing.Color]::FromArgb(160, 160, 160)
$colInputBg     = [System.Drawing.Color]::FromArgb(60, 60, 64)
$colBorder      = [System.Drawing.Color]::FromArgb(70, 70, 74)

# ---------- Fonts ----------
$fontTitle   = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$fontNormal  = New-Object System.Drawing.Font("Segoe UI", 9.5)
$fontSmall   = New-Object System.Drawing.Font("Segoe UI", 8.5)
$fontButton  = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)

# ---------- Form ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "Intune Diagnostic Tool"
$form.Size = New-Object System.Drawing.Size(520, 410)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = $colBg
$form.ForeColor = $colTextPrimary
$form.Font = $fontNormal

# ---------- Title Bar Area ----------
$panelHeader = New-Object System.Windows.Forms.Panel
$panelHeader.Dock = "Top"
$panelHeader.Height = 64
$panelHeader.BackColor = $colSurface
$form.Controls.Add($panelHeader)

# Logo from web (cached locally)
$logoSize = 44
$logoPadLeft = 14
$logoPadTop = 10
$logoPath = Join-Path $ScriptFolder "IntuneDiag_logo.png"

$picLogo = New-Object System.Windows.Forms.PictureBox
$picLogo.Location = New-Object System.Drawing.Point($logoPadLeft, $logoPadTop)
$picLogo.Size = New-Object System.Drawing.Size($logoSize, $logoSize)
$picLogo.SizeMode = "Zoom"
$picLogo.BackColor = [System.Drawing.Color]::Transparent

try {
    # Use cached logo if available, otherwise download
    if (Test-Path $logoPath) {
        $picLogo.Image = [System.Drawing.Image]::FromFile($logoPath)
    } else {
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile("https://scloud.work/wp-content/uploads/Intune-Diag.png", $logoPath)
        $picLogo.Image = [System.Drawing.Image]::FromFile($logoPath)
    }
    # Set as taskbar / title bar icon
    $iconBmp = New-Object System.Drawing.Bitmap($picLogo.Image, 32, 32)
    $hIcon = $iconBmp.GetHicon()
    $form.Icon = [System.Drawing.Icon]::FromHandle($hIcon)
} catch {
    # Silently ignore – logo is decorative only
}
$panelHeader.Controls.Add($picLogo)

$textLeft = $logoPadLeft + $logoSize + 10

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Intune Diagnostic Tool"
$lblTitle.Font = $fontTitle
$lblTitle.ForeColor = $colTextPrimary
$lblTitle.AutoSize = $true
$lblTitle.Location = New-Object System.Drawing.Point($textLeft, 10)
$panelHeader.Controls.Add($lblTitle)

$lblSubtitle = New-Object System.Windows.Forms.Label
$lblSubtitle.Text = "Analyze Intune & Autopilot logs with ease"
$lblSubtitle.Font = $fontSmall
$lblSubtitle.ForeColor = $colTextMuted
$lblSubtitle.AutoSize = $true
$lblSubtitle.Location = New-Object System.Drawing.Point(($textLeft + 2), 38)
$panelHeader.Controls.Add($lblSubtitle)

# ---------- Script Selector ----------
$lblScript = New-Object System.Windows.Forms.Label
$lblScript.Text = "Diagnostic Script"
$lblScript.Font = $fontSmall
$lblScript.ForeColor = $colTextMuted
$lblScript.Location = New-Object System.Drawing.Point(20, 78)
$lblScript.Size = New-Object System.Drawing.Size(460, 18)
$form.Controls.Add($lblScript)

$comboScript = New-Object System.Windows.Forms.ComboBox
$comboScript.Location = New-Object System.Drawing.Point(20, 98)
$comboScript.Size = New-Object System.Drawing.Size(460, 28)
$comboScript.DropDownStyle = "DropDownList"
$comboScript.FlatStyle = "Flat"
$comboScript.BackColor = $colInputBg
$comboScript.ForeColor = $colTextPrimary
$comboScript.Font = $fontNormal
foreach ($ds in $DiagScripts) {
    $comboScript.Items.Add($ds.Label) | Out-Null
}
$comboScript.SelectedIndex = 0
$form.Controls.Add($comboScript)

# ---------- Availability Indicator ----------
$lblAvail = New-Object System.Windows.Forms.Label
$lblAvail.Font = $fontSmall
$lblAvail.Location = New-Object System.Drawing.Point(20, 130)
$lblAvail.Size = New-Object System.Drawing.Size(460, 18)
$form.Controls.Add($lblAvail)

function Update-Availability {
    $idx = $comboScript.SelectedIndex
    $scriptPath = Join-Path $ScriptFolder $DiagScripts[$idx].FileName
    if (Test-Path $scriptPath) {
        $lblAvail.Text = [char]0x2713 + " Script ready"
        $lblAvail.ForeColor = $colSuccess
    } else {
        $lblAvail.Text = [char]0x2717 + " Script not found - will attempt download on run"
        $lblAvail.ForeColor = $colWarning
    }
}
$comboScript.add_SelectedIndexChanged({ Update-Availability })
Update-Availability

# ---------- Path Input ----------
$lblPath = New-Object System.Windows.Forms.Label
$lblPath.Text = "Log Folder or ZIP/CAB File  (drag & drop supported)"
$lblPath.Font = $fontSmall
$lblPath.ForeColor = $colTextMuted
$lblPath.Location = New-Object System.Drawing.Point(20, 160)
$lblPath.Size = New-Object System.Drawing.Size(460, 18)
$form.Controls.Add($lblPath)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(20, 180)
$textBox.Size = New-Object System.Drawing.Size(380, 28)
$textBox.AllowDrop = $true
$textBox.BackColor = $colInputBg
$textBox.ForeColor = $colTextPrimary
$textBox.BorderStyle = "FixedSingle"
$textBox.Font = $fontNormal
$form.Controls.Add($textBox)

# Browse button
$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "..."
$btnBrowse.Location = New-Object System.Drawing.Point(405, 179)
$btnBrowse.Size = New-Object System.Drawing.Size(75, 28)
$btnBrowse.FlatStyle = "Flat"
$btnBrowse.BackColor = $colSurface
$btnBrowse.ForeColor = $colTextPrimary
$btnBrowse.Font = $fontButton
$btnBrowse.FlatAppearance.BorderColor = $colBorder
$btnBrowse.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnBrowse)

$btnBrowse.add_Click({
    $dlg = New-Object System.Windows.Forms.OpenFileDialog
    $dlg.Title = "Select a ZIP, CAB, or log file"
    $dlg.Filter = "Supported files (*.zip;*.cab)|*.zip;*.cab|All files (*.*)|*.*"
    $dlg.CheckFileExists = $true
    if ($dlg.ShowDialog() -eq "OK") {
        $textBox.Text = $dlg.FileName
    }
})

# ---------- Drag & Drop ----------
$textBox.add_DragEnter({
    param($sender, $e)
    if ($e.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $e.Effect = [Windows.Forms.DragDropEffects]::Copy
    } else {
        $e.Effect = [Windows.Forms.DragDropEffects]::None
    }
})

$textBox.add_DragDrop({
    param($sender, $e)
    $items = $e.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($items.Count -eq 1 -and (Test-Path $items[0])) {
        $textBox.Text = $items[0]
    } else {
        [System.Windows.Forms.MessageBox]::Show(
            "Please drop only one valid folder, ZIP, or CAB file.",
            "Invalid Input",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
})

# ---------- Buttons ----------
$btnAnalyzeFolder = New-Object System.Windows.Forms.Button
$btnAnalyzeFolder.Text = "Analyze Path"
$btnAnalyzeFolder.Location = New-Object System.Drawing.Point(20, 225)
$btnAnalyzeFolder.Size = New-Object System.Drawing.Size(220, 40)
$btnAnalyzeFolder.FlatStyle = "Flat"
$btnAnalyzeFolder.BackColor = $colAccent
$btnAnalyzeFolder.ForeColor = $colTextPrimary
$btnAnalyzeFolder.Font = $fontButton
$btnAnalyzeFolder.FlatAppearance.BorderSize = 0
$btnAnalyzeFolder.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnAnalyzeFolder)

# Hover effect
$btnAnalyzeFolder.add_MouseEnter({ $this.BackColor = $colAccentHover })
$btnAnalyzeFolder.add_MouseLeave({ $this.BackColor = $colAccent })

$btnAnalyzePC = New-Object System.Windows.Forms.Button
$btnAnalyzePC.Text = "Analyze This PC"
$btnAnalyzePC.Location = New-Object System.Drawing.Point(260, 225)
$btnAnalyzePC.Size = New-Object System.Drawing.Size(220, 40)
$btnAnalyzePC.FlatStyle = "Flat"
$btnAnalyzePC.BackColor = $colSurface
$btnAnalyzePC.ForeColor = $colTextPrimary
$btnAnalyzePC.Font = $fontButton
$btnAnalyzePC.FlatAppearance.BorderColor = $colBorder
$btnAnalyzePC.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnAnalyzePC)

$btnAnalyzePC.add_MouseEnter({ $this.BackColor = $colBorder })
$btnAnalyzePC.add_MouseLeave({ $this.BackColor = $colSurface })

# ---------- Status ----------
$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(20, 280)
$lblStatus.Size = New-Object System.Drawing.Size(460, 20)
$lblStatus.Font = $fontSmall
$lblStatus.ForeColor = $colTextMuted
$lblStatus.Text = ""
$form.Controls.Add($lblStatus)

# ---------- Progress Bar ----------
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 302)
$progressBar.Size = New-Object System.Drawing.Size(460, 6)
$progressBar.Style = "Marquee"
$progressBar.MarqueeAnimationSpeed = 30
$progressBar.Visible = $false
$form.Controls.Add($progressBar)

# ---------- Footer ----------
$lblFooter = New-Object System.Windows.Forms.LinkLabel
$lblFooter.Text = "scloud  |  v2.0"
$lblFooter.Font = $fontSmall
$lblFooter.LinkColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$lblFooter.ActiveLinkColor = $colAccent
$lblFooter.VisitedLinkColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$lblFooter.DisabledLinkColor = [System.Drawing.Color]::FromArgb(80, 80, 80)
$lblFooter.TextAlign = "MiddleCenter"
$lblFooter.Dock = "Bottom"
$lblFooter.Height = 30
$lblFooter.LinkArea = New-Object System.Windows.Forms.LinkArea(0, 6)  # only "scloud" is clickable
$lblFooter.add_LinkClicked({
    Start-Process "https://scloud.work/Intune-Diag"
})
$form.Controls.Add($lblFooter)

#########################################################################################
# Functions
#########################################################################################

function Set-UIBusy {
    param([bool]$Busy, [string]$Message = "")
    $lblStatus.Text = $Message
    $progressBar.Visible = $Busy
    $btnAnalyzeFolder.Enabled = -not $Busy
    $btnAnalyzePC.Enabled = -not $Busy
    $comboScript.Enabled = -not $Busy
    $btnBrowse.Enabled = -not $Busy
    if ($Busy) {
        $form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
        $lblStatus.ForeColor = $colAccent
    } else {
        $form.Cursor = [System.Windows.Forms.Cursors]::Default
    }
    $form.Refresh()
}

function Get-SelectedScript {
    $idx = $comboScript.SelectedIndex
    return $DiagScripts[$idx]
}

function Ensure-ScriptAvailable {
    param($ScriptDef)
    $path = Join-Path $ScriptFolder $ScriptDef.FileName
    if (!(Test-Path $path)) {
        Set-UIBusy -Busy $true -Message "Downloading $($ScriptDef.Name)..."
        try {
            Save-Script $ScriptDef.Name -Path $ScriptFolder -Force -ErrorAction Stop
        } catch {
            [System.Windows.Forms.MessageBox]::Show(
                "Failed to download $($ScriptDef.Name):`n$_",
                "Download Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error
            )
            Set-UIBusy -Busy $false -Message "Download failed."
            $lblStatus.ForeColor = $colError
            return $null
        }
    }
    if (Test-Path $path) { return $path } else { return $null }
}

function Start-Analysis {
    param([string]$InputPath)

    $scriptDef = Get-SelectedScript
    $scriptPath = Ensure-ScriptAvailable -ScriptDef $scriptDef
    if (-not $scriptPath) { return }

    Set-UIBusy -Busy $true -Message "Running $($scriptDef.Name)..."

    $logTarget = $InputPath

    # Handle ZIP extraction for IME Diagnostics (it expects a folder, not a ZIP)
    if ($scriptDef.Name -eq "Get-IntuneManagementExtensionDiagnostics" -and $InputPath -match '\.(zip)$') {
        $extractPath = Join-Path $env:TEMP "IntuneDiag_$(Get-Random)"
        try {
            Expand-Archive -Path $InputPath -DestinationPath $extractPath -Force
            $logTarget = $extractPath
        } catch {
            [System.Windows.Forms.MessageBox]::Show(
                "Error extracting ZIP file:`n$_",
                "Extraction Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Error
            )
            Set-UIBusy -Busy $false -Message "Analysis failed."
            $lblStatus.ForeColor = $colError
            return
        }
    }

    # Build argument string
    $isFolder = (Test-Path $logTarget -PathType Container)
    $isFile   = (Test-Path $logTarget -PathType Leaf)

    if ($scriptDef.Name -eq "Get-IntuneManagementExtensionDiagnostics") {
        # IME Diagnostics always uses -LogFilesFolder (folder path)
        $argString = $scriptDef.FolderArg -f $logTarget
    } elseif ($isFile) {
        # Autopilot scripts: pass file directly with -File / -ZIPFile
        $argString = $scriptDef.FileArg -f $logTarget
    } else {
        # If a folder was given but the Autopilot script expects a file,
        # look for a .zip or .cab inside
        $archiveFile = Get-ChildItem -Path $logTarget -Include *.zip, *.cab -Recurse -File | Select-Object -First 1
        if ($archiveFile) {
            $argString = $scriptDef.FileArg -f $archiveFile.FullName
        } else {
            # Fall back: try passing the folder anyway
            $argString = $scriptDef.FolderArg -f $logTarget
        }
    }

    try {
        $psArgs = "-ExecutionPolicy Bypass -File `"$scriptPath`" $argString"
        Start-Process -FilePath "powershell.exe" -ArgumentList $psArgs -NoNewWindow -Wait
        Set-UIBusy -Busy $false -Message "Analysis completed successfully."
        $lblStatus.ForeColor = $colSuccess
    } catch {
        Set-UIBusy -Busy $false -Message "Analysis encountered an error."
        $lblStatus.ForeColor = $colError
    }

    Update-Availability
}

function Start-LocalAnalysis {
    $scriptDef = Get-SelectedScript
    $scriptPath = Ensure-ScriptAvailable -ScriptDef $scriptDef
    if (-not $scriptPath) { return }

    Set-UIBusy -Busy $true -Message "Running $($scriptDef.Name) on this PC..."

    try {
        $psArgs = "-ExecutionPolicy Bypass -File `"$scriptPath`" $($scriptDef.LocalArg)"
        Start-Process -FilePath "powershell.exe" -ArgumentList $psArgs.Trim() -NoNewWindow -Wait
        Set-UIBusy -Busy $false -Message "Local analysis completed successfully."
        $lblStatus.ForeColor = $colSuccess
    } catch {
        Set-UIBusy -Busy $false -Message "Local analysis encountered an error."
        $lblStatus.ForeColor = $colError
    }

    Update-Availability
}

#########################################################################################
# Button Events
#########################################################################################
$btnAnalyzeFolder.add_Click({
    $path = $textBox.Text.Trim()
    if ([string]::IsNullOrWhiteSpace($path) -or -not (Test-Path $path)) {
        [System.Windows.Forms.MessageBox]::Show(
            "Please enter or drag & drop a valid folder, ZIP, or CAB file first.",
            "No Input",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        return
    }
    Start-Analysis -InputPath $path
})

$btnAnalyzePC.add_Click({
    Start-LocalAnalysis
})

#########################################################################################
# Show Form
#########################################################################################
$form.ShowDialog() | Out-Null