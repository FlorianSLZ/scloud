$PackageName = "WIN-D-DownloadWallpaper"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-script.log" -Force

$Wallpaper_online = "https://github.com/FlorianSLZ/scloud/blob/main/img/scloud-wallpaper.jpg"
$Wallpaper_local = "C:\Windows\Wallpaper.jpg"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, "C:\temp\test.jpg")

Stop-Transcript
