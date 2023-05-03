$PackageName = "HelpdeskInfo"

$Path_local = "$Env:Programfiles\_MEM"
Start-Transcript -Path "$Path_local\Log\$PackageName-install.log" -Force

try{
    $SysT_Name = "Helpdesk Info"
    $SysT_Folder = "$env:Programdata\$SysT_Name"

    # Remove Task
    $schtaskName = "$PackageName"
    Unregister-ScheduledTask -TaskName $schtaskName -Confirm:$false

    # remove local Path
    Remove-Item -Path $SysT_Folder -Recurse -Force


}catch{
    Write-Error $_
}

Stop-Transcript

