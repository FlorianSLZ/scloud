$PackageName = "DesktopIcon_SLZ"
$Version = "1"

$Path_local = "$Env:Programfiles\MEM"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

# Paths
$DesktopTMP = "$Path_local\Data\Desktop\$PackageName"
$DesktopIcons = "$Path_local\Data\icons\$PackageName"

# Create Folders
New-Item -Path $DesktopTMP -ItemType directory -force
New-Item -Path $DesktopIcons -ItemType directory -force
New-Item -Path "C:\Users\Public\Desktop" -ItemType directory -force

# Remove old shortcuts and icons
$OLD_Items = Get-ChildItem -Path $DesktopTMP
foreach($OLD_Item in $OLD_Items){
    Remove-Item "C:\Users\Public\Desktop\$($OLD_Item.Name)" -Force
}
Remove-Item "$DesktopTMP\*" -Force
Remove-Item "$DesktopIcons\*" -Force

# Copy New shortcuts
Copy-Item -Path ".\Desktop\*" -Destination $DesktopTMP -Recurse
Copy-Item -Path ".\icons\*" -Destination $DesktopIcons -Recurse

# shortcuts from list
$shortcuts = Import-CSV "link-list.csv"
foreach($shortcut in $shortcuts){
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut_file = $WshShell.CreateShortcut("$DesktopTMP\$($shortcut.name).lnk")
    $Shortcut_file.TargetPath = $shortcut.link
    $Shortcut_file.IconLocation = "$DesktopIcons\$($shortcut.icon)"
    $Shortcut_file.Save()
}

# Copy icons to public Desktop
Copy-Item -Path "$DesktopTMP\*" -Destination "C:\Users\Public\Desktop" -Recurse

# Validation
New-Item -Path "$Path_local\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript

