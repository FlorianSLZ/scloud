<#PSScriptInfo

.VERSION 1.2
.GUID b00d1997-e4fa-4af1-86f0-49220c606238
.AUTHOR Florian Salzmann
.COMPANYNAME scloud.work
.COPYRIGHT 2025 Florian Salzmann. GPL-3.0 license.
.TAGS PowerShell Intune Diagnostics LogAnalyzer
.LICENSEURI https://github.com/FlorianSLZ/scloud/blob/main/LICENSE
.PROJECTURI https://github.com/FlorianSLZ/scloud/tree/main/scripts/Intune-Diag
.ICONURI https://scloud.work/wp-content/uploads/Intune-Diag.webp 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
    2024-09-26, 1.0:    Original published version.
    2025-03-14, 1.1:    Minor improvements
    2025-03-14, 1.2:    Changed to English, improved Errorhandling and loader, Added button for local analysis

#> 

<# 

.DESCRIPTION 
A simple PowerShell-based tool for analyzing Intune Management Extension logs and diagnostics.
Quickly troubleshoot Intune issues with an intuitive UI and built-in ZIP extraction.

This script provides a simple UI to analyze Intune Management Extension logs.
- Drag & Drop a folder or ZIP file
- Click "Analyze"
- The script will run the diagnostics script on the selected logs

All Kudos for the logic behind the diagnostics script go to the original author: 
- Petri Paavola
- https://github.com/petripaavola/Get-IntuneManagementExtensionDiagnostics

#> 


#########################################################################################
# Initial Setup
#########################################################################################
$PackageName = "IntuneDiagnostic-miniUI"
$ScriptFolder = "C:\ProgramData\$PackageName"
$ScriptName = "Get-IntuneManagementExtensionDiagnostics.ps1"
$ScriptPath = "$ScriptFolder\$ScriptName"

#########################################################################################
# Download Script
#########################################################################################
if (!(Test-Path $ScriptFolder)) {
    New-Item -Path $ScriptFolder -Type Directory -Force
}

if (!(Test-Path $ScriptPath)) {
    try {
        Save-Script Get-IntuneManagementExtensionDiagnostics -Path $ScriptFolder -Force -ErrorAction Stop
    } catch {
        Write-Host "Error downloading the script: $_" -ForegroundColor Red
        exit
    }
}

#########################################################################################
# Execution Policy Check
#########################################################################################
$CurrentPolicy = Get-ExecutionPolicy -Scope Process
if ($CurrentPolicy -ne "Bypass") {
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
}

#########################################################################################
# UI / Function
#########################################################################################
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Intune Diagnostic Tool"
$form.Size = New-Object System.Drawing.Size(420, 220)
$form.StartPosition = "CenterScreen"

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(380, 20)
$label.Text = "Drag & Drop a folder or ZIP file below:"
$form.Controls.Add($label)

# Create a text box
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 50)
$textBox.Size = New-Object System.Drawing.Size(380, 20)
$textBox.AllowDrop = $true
$form.Controls.Add($textBox)

# Create an "Analyze Folder" button
$buttonAnalyzeFolder = New-Object System.Windows.Forms.Button
$buttonAnalyzeFolder.Location = New-Object System.Drawing.Point(10, 80)
$buttonAnalyzeFolder.Size = New-Object System.Drawing.Size(120, 30)
$buttonAnalyzeFolder.Text = "Analyze Folder"
$form.Controls.Add($buttonAnalyzeFolder)

# Create an "Analyze This PC" button
$buttonAnalyzePC = New-Object System.Windows.Forms.Button
$buttonAnalyzePC.Location = New-Object System.Drawing.Point(140, 80)
$buttonAnalyzePC.Size = New-Object System.Drawing.Size(120, 30)
$buttonAnalyzePC.Text = "Analyze This PC"
$form.Controls.Add($buttonAnalyzePC)

# Progress Label (Status Message)
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 120)
$statusLabel.Size = New-Object System.Drawing.Size(380, 20)
$statusLabel.Text = ""
$form.Controls.Add($statusLabel)

# Drag-and-Drop Handler
$textBox_DragEnter = {
    param($sender, $e)
    if ($e.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $e.Effect = [Windows.Forms.DragDropEffects]::Copy
    } else {
        $e.Effect = [Windows.Forms.DragDropEffects]::None
    }
}
$textBox.add_DragEnter($textBox_DragEnter)

$textBox_DragDrop = {
    param($sender, $e)
    $droppedItems = $e.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($droppedItems.Count -eq 1 -and (Test-Path $droppedItems[0])) {
        $textBox.Text = $droppedItems[0]
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please drop only one valid folder or ZIP file.")
    }
}
$textBox.add_DragDrop($textBox_DragDrop)

# Function to Start Analysis with Spinner & ZIP Extraction
function Start-Analysis {
    param($LogFiles)

    # Show Loading Indicator
    $statusLabel.Text = "Running analysis..."
    $form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $buttonAnalyzeFolder.Enabled = $false
    $buttonAnalyzePC.Enabled = $false
    $form.Refresh()

    # Check if input is a ZIP file and extract it
    if ($LogFiles -match "\.zip$") {
        $ExtractedPath = "$env:temp\IntuneDiagnostics_$(Get-Random)"
        try {
            Expand-Archive -Path $LogFiles -DestinationPath $ExtractedPath -Force
            $LogFiles = $ExtractedPath
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error extracting ZIP file: $_")
            # Reset UI on failure
            $statusLabel.Text = "Analysis failed."
            $form.Cursor = [System.Windows.Forms.Cursors]::Default
            $buttonAnalyzeFolder.Enabled = $true
            $buttonAnalyzePC.Enabled = $true
            $form.Refresh()
            return
        }
    }

    # Run the script
    if (Test-Path $ScriptPath) {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`" -LogFilesFolder `"$LogFiles`"" -NoNewWindow -Wait
    } else {
        [System.Windows.Forms.MessageBox]::Show("Diagnostic script not found.")
        # Reset UI if script is missing
        $statusLabel.Text = "Analysis failed."
        $form.Cursor = [System.Windows.Forms.Cursors]::Default
        $buttonAnalyzeFolder.Enabled = $true
        $buttonAnalyzePC.Enabled = $true
        $form.Refresh()
        return
    }

    # Hide Loading Indicator after completion
    $statusLabel.Text = "Analysis completed."
    $form.Cursor = [System.Windows.Forms.Cursors]::Default
    $buttonAnalyzeFolder.Enabled = $true
    $buttonAnalyzePC.Enabled = $true
    $form.Refresh()
}

# Function for Analyzing This PC
function Analyze-ThisPC {
    # Show Loading Indicator
    $statusLabel.Text = "Running analysis..."
    $form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor
    $buttonAnalyzeFolder.Enabled = $false
    $buttonAnalyzePC.Enabled = $false
    $form.Refresh()

    # Run the script for local analysis
    if (Test-Path $ScriptPath) {
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$ScriptPath`"" -NoNewWindow -Wait
    } else {
        [System.Windows.Forms.MessageBox]::Show("Diagnostic script not found.")
        $statusLabel.Text = "Analysis failed."
    }

    # Reset UI
    $statusLabel.Text = "Analysis completed."
    $form.Cursor = [System.Windows.Forms.Cursors]::Default
    $buttonAnalyzeFolder.Enabled = $true
    $buttonAnalyzePC.Enabled = $true
    $form.Refresh()
}

# Button Click Handlers
$buttonAnalyzeFolder.add_Click({
    if (-not [string]::IsNullOrWhiteSpace($textBox.Text) -and (Test-Path $textBox.Text)) {
        Start-Analysis -LogFiles $textBox.Text
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a valid folder or ZIP file first.")
    }
})

$buttonAnalyzePC.add_Click({
    Analyze-ThisPC
})

# Show the form
$form.ShowDialog() | Out-Null
