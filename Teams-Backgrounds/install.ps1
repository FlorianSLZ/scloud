$PackageName = "Teams-Backgrounds"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-$env:USERNAME-install.log" -Force


# Lokaler Ordner 
$TeamsBG_Folder = "$env:APPDATA\Microsoft\Teams\Backgrounds\Uploads"
 
# Sicherstelen, das der Ordner vorhanden ist
New-Item -ItemType directory -Path $TeamsBG_Folder -Force
 
# Hintergründe kopieren
Copy-Item -path '.\bg' -Filter *.* -Destination $TeamsBG_Folder -Recurse

New-Item -Path "$env:localAPPDATA\4net\EndpointManager\Validation\$PackageName" -ItemType "file" -Force

Stop-Transcript



