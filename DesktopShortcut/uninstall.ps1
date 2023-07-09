$PackageName = "DesktopIcon_SLZ"

$Path_local = "$Env:Programfiles\MEM"
Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-uninstall.log" -Force

# remove old icons form package
$DesktopTMP = "$Path_local\Data\Desktop\$PackageName"
$OLD_Items = Get-ChildItem -Path $DesktopTMP
foreach($OLD_Item in $OLD_Items){
    Remove-Item "C:\Users\Public\Desktop\$($OLD_Item.Name)" -Force
}
Remove-Item "$DesktopTMP" -Force -Recurse

# remove validation file wit version
Remove-Item -Path "$Path_local\Validation\$PackageName" -Force

Stop-Transcript

