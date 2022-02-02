$PackageName = "DesktopIcon_SLZ"
$Version = "1"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

# Paths
$DesktopTMP = "$Path_4netIntune\Data\Desktop\$PackageName"
$DesktopIcons = "$Path_4netIntune\Data\Desktop\icons"

# Create Folders
New-Item -Path $DesktopTMP -ItemType directory -force
New-Item -Path $DesktopIcons -ItemType directory -force
New-Item -Path "C:\Users\Public\Desktop" -ItemType directory -force

# Remove old icons
$OLD_Items = Get-ChildItem -Path $DesktopTMP
foreach($OLD_Item in $OLD_Items){
    Remove-Item "C:\Users\Public\Desktop\$($OLD_Item.Name)" -Force
}
Remove-Item "$DesktopTMP\*" -Force

# Icons from list
$icons = import-csv link-list.csv
foreach($icon in $icons){
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("$DesktopTMP\$($icon.name).lnk")
    $Shortcut.TargetPath = $icon.link
    $Shortcut.Save()
}

# Copy New icons
Copy-Item -Path ".\Desktop\*" -Destination $DesktopTMP -Recurse
Copy-Item -Path ".\icons\*" -Destination $DesktopIcons -Recurse
Copy-Item -Path "$DesktopTMP\*" -Destination "C:\Users\Public\Desktop" -Recurse

# Validation
New-Item -Path "$Path_4netIntune\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript

