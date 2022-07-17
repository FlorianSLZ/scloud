$PackageName = "Teams-Backgrounds"

$Path_4Log = "$ENV:LOCALAPPDATA\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$PackageName-uninstall.log" -Force

$TeamsBG_Folder = "$env:APPDATA\Microsoft\Teams\Backgrounds\Uploads"
$TeamsBG_Files = Get-ChildItem -Path '.\bg' -Name

# Verteilte Hintergründe löschen
Get-ChildItem $TeamsBG_Folder | Where{$_.Name -in $TeamsBG_Files} | Remove-Item

# Erkennungs File löschen
Remove-Item -Path "$Path_4Log\Validation\$PackageName" -Force

Stop-Transcript