$ProgramName = "eOpale"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$ProgramName-uninstall.log" -Force

$DesktopTMP = "$Path_4netIntune\Data\Desktop\$ProgramName"
New-Item -Path $DesktopTMP -ItemType directory -force

$OLD_Items = Get-ChildItem -Path $DesktopTMP
foreach($OLD_Item in $OLD_Items){
    Remove-Item "C:\Users\Public\Desktop\$($OLD_Item.Name)" -Force
}
Remove-Item "$DesktopTMP" -Force -Recurse
Remove-Item -Path "C:\Admin\Intune\Validation\$PackageName" -Force

Stop-Transcript

