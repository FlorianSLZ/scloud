$PackageName = "Teams-Backgrounds"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$PackageName-$env:USERNAME-uninstall.log" -Force

$TeamsBG_Folder = "$env:APPDATA\Microsoft\Teams\Backgrounds\Uploads"
$TeamsBG_Files = Get-ChildItem -Path '.\bg' -Name

# Verteilte Hintergründe löschen
Get-ChildItem $TeamsBG_Folder | Where{$_.Name -in $TeamsBG_Files} | Remove-Item

# Erkennungs File löschen
Remove-Item -Path "$env:localAPPDATA\Intune\Validation\$PackageName" -Force

Stop-Transcript