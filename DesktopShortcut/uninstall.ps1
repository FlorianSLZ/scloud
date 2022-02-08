$PackageName = "DesktopIcon_SLZ"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\uninstall\$ProgramName-uninstall.log" -Force

# remove old icons form package
$DesktopTMP = "$Path_4netIntune\Data\Desktop\$PackageName"
$OLD_Items = Get-ChildItem -Path $DesktopTMP
foreach($OLD_Item in $OLD_Items){
    Remove-Item "C:\Users\Public\Desktop\$($OLD_Item.Name)" -Force
}
Remove-Item "$DesktopTMP" -Force -Recurse

# remove validation file wit version
Remove-Item -Path "$Path_4netIntune\Validation\$PackageName" -Force

Stop-Transcript

