$PackageName = "Teams-Backgrounds"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-$env:USERNAME-uninstall.log" -Force

$TeamsBG_Folder = "$env:APPDATA\Microsoft\Teams\Backgrounds\Uploads"
$TeamsBG_Files = Get-ChildItem -Path '.\bg' -Name

# delete deployed wallpapers
Get-ChildItem $TeamsBG_Folder | Where-Object{$_.Name -in $TeamsBG_Files} | Remove-Item

# delete detection
Remove-Item "HKCU:\SOFTWARE\scloud\Packages\$PackageName"

Stop-Transcript