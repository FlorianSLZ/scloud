#########################################################################################
# Inital
#########################################################################################
$PackageName = "IntuneDiagnostic-miniUI"
$ScriptFolder = "C:\ProgramData\$PackageName"
$ScriptName = "Get-IntuneManagementExtensionDiagnostics.ps1"
$ScriptPath = "$ScriptFolder\$ScriptName"

#########################################################################################
# Download
#########################################################################################
if(!$(Test-Path $ScriptFolder)){New-Item -Path $ScriptFolder -Type Directory -Force}
if(!$(Test-Path $ScriptPath)){
    Save-Script Get-IntuneManagementExtensionDiagnostics -Path $ScriptFolder -Force
}


Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force


#########################################################################################
# UI / Function
#########################################################################################
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Select Folder"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

# Create a label for the text box
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,30)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = "Drag and drop a folder here:"
$form.Controls.Add($label)

# Create a text box
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10,60)
$textBox.Size = New-Object System.Drawing.Size(380,20)
$textBox.AllowDrop = $true
$form.Controls.Add($textBox)

# Add event handler for when a folder is dropped onto the text box
$textBox_DragEnter = {
    param($sender, $e)
    if ($e.Data.GetDataPresent([Windows.Forms.DataFormats]::FileDrop)) {
        $e.Effect = [Windows.Forms.DragDropEffects]::Copy
    } else {
        $e.Effect = [Windows.Forms.DragDropEffects]::None
    }
}

$textBox.add_DragEnter($textBox_DragEnter)

# Add event handler for when a folder is dropped onto the text box
$textBox_DragDrop = {
    param($sender, $e)
    $droppedItems = $e.Data.GetData([Windows.Forms.DataFormats]::FileDrop)
    if ($droppedItems.Count -eq 1 -and (Test-Path $droppedItems[0] -PathType Container)) {
        $textBox.Text = $droppedItems[0]
        # Call your script with the selected folder parameter
        if (Test-Path $scriptPath) {
            & $scriptPath -LogFilesFolder $droppedItems[0]
        } else {
            Write-Host "Script not found at $scriptPath"
        }
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please drop only one folder.")
    }
}

$textBox.add_DragDrop($textBox_DragDrop)

# Add controls to the form
$form.Controls.Add($textBox)

# Show the form
$form.ShowDialog() | Out-Null
