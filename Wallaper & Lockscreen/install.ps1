$PackageName = "Wallpaper"
$Version = 1

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

New-item -itemtype directory -force -path "$Path_4netIntune\Data"

$BG_LocalImage = "$Path_4netIntune\Data\bg.jpg"
Copy-item -path ".\Data\bg.jpg" -destination $BG_LocalImage -Force

# Wallpaper
.\Data\Set-Screen.ps1 -BackgroundSource $BG_LocalImage

# LockScreen
.\Data\Set-Screen.ps1 -LockScreenSource $BG_LocalImage

New-Item -Path "$Path_4netIntune\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript
