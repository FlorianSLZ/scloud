$PackageName = "Wallpaper"

# Set image file names for desktop background and lock screen
# leave blank if you with not to set either of one
$WallpaperIMG = "wallpaper-scloud.jpg"
$LockscreenIMG = "scloud-banner.jpg"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force
$ErrorActionPreference = "Stop"

# Set variables for registry key path and names of registry values to be modified
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$DesktopPath = "DesktopImagePath"
$DesktopStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"

# Check whether both image file variables have values, output warning message and exit if either is missing
if (!$LockscreenIMG -and !$WallpaperIMG){
    Write-Warning "Either LockscreenIMG or WallpaperIMG must has a value."
}
else{
    # Check whether registry key path exists, create it if it does not
    if(!(Test-Path $RegKeyPath)){
        Write-Warning "The path ""$RegKeyPath"" does not exists. Therefore no wallpaper or lockscreen is set by this package."
    }
    if ($LockscreenIMG){
        Write-Host "Deleting regkeys for lockscreen"
        Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Force
        Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Force
        Remove-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Force
    }
    if ($WallpaperIMG){
        Write-Host "Deleting regkeys for wallpaper"
        Remove-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Force
        Remove-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Force
        Remove-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Force
    }  
}

Write-Host "Deleting Validation file."
Remove-Item -Path "C:\ProgramData\scloud\Validation\$PackageName" -Force

Stop-Transcript
