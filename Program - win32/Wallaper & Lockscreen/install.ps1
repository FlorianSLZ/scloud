$PackageName = "Wallpaper"
$Version = 1

# Set image file names for desktop background and lock screen
# leave blank if you with not to set either of one
$WallpaperIMG = "wallpaper-scloud.jpg"
$LockscreenIMG = "scloud-banner.jpg"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force
$ErrorActionPreference = "Stop"

# Set variables for registry key path and names of registry values to be modified
$RegKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP"
$DesktopPath = "DesktopImagePath"
$DesktopStatus = "DesktopImageStatus"
$DesktopUrl = "DesktopImageUrl"
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"
$StatusValue = "1"

# local path of images
$WallpaperLocalIMG = "C:\Windows\System32\Desktop.jpg"
$LockscreenLocalIMG = "C:\Windows\System32\Lockscreen.jpg"

# Check whether both image file variables have values, output warning message and exit if either is missing
if (!$LockscreenIMG -and !$WallpaperIMG){
    Write-Warning "Either LockscreenIMG or WallpaperIMG must has a value."
}
else{
    # Check whether registry key path exists, create it if it does not
    if(!(Test-Path $RegKeyPath)){
        Write-Host "Creating registry path: $($RegKeyPath)."
        New-Item -Path $RegKeyPath -Force
    }
    if ($LockscreenIMG){
        Write-Host "Copy lockscreen ""$($LockscreenIMG)"" to ""$($LockscreenLocalIMG)"""
        Copy-Item ".\Data\$LockscreenIMG" $LockscreenLocalIMG -Force
        Write-Host "Creating regkeys for lockscreen"
        New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $StatusValue -PropertyType DWORD -Force
        New-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $LockscreenLocalIMG -PropertyType STRING -Force
        New-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $LockscreenLocalIMG -PropertyType STRING -Force
    }
    if ($WallpaperIMG){
        Write-Host "Copy wallpaper ""$($WallpaperIMG)"" to ""$($WallpaperLocalIMG)"""
        Copy-Item ".\Data\$WallpaperIMG" $WallpaperLocalIMG -Force
        Write-Host "Creating regkeys for wallpaper"
        New-ItemProperty -Path $RegKeyPath -Name $DesktopStatus -Value $StatusValue -PropertyType DWORD -Force
        New-ItemProperty -Path $RegKeyPath -Name $DesktopPath -Value $WallpaperLocalIMG -PropertyType STRING -Force
        New-ItemProperty -Path $RegKeyPath -Name $DesktopUrl -Value $WallpaperLocalIMG -PropertyType STRING -Force
    }  
}


New-Item -Path "C:\ProgramData\scloud\Validation\$PackageName" -ItemType "file" -Force -Value $Version

Stop-Transcript
