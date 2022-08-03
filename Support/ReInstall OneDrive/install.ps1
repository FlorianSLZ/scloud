$PackageName = "ReInstall_OneDrive"

$Path_4Log = "$ENV:Programfiles\_MEM"
Start-Transcript -Path "$Path_4Log\Log\$ProgramName-install.log" -Force
##############################################################################################
#   Unsinatall OneDrive
##############################################################################################
# End OneDrive
taskkill /f /im OneDrive.exe

if(Test-Path "$ENV:systemroot\System32\OneDriveSetup.exe") {
    & "$ENV:systemroot\System32\OneDriveSetup.exe" /uninstall
}elseif(Test-Path "$ENV:systemroot\SysWOW64\OneDriveSetup.exe") {
    & "$ENV:systemroot\SysWOW64\OneDriveSetup.exe" /uninstall
}elseif(Test-Path "$ENV:Programfiles\Microsoft OneDrive\OneDrive.exe"){
    & "$ENV:Programfiles\Microsoft OneDrive\OneDrive.exe" /uninstall
}else{
## Remove Microsoft OneDrive (User Profile)
    $Users = Get-ChildItem C:\Users
    foreach ($user in $Users){
        $OneDrive = "$($user.fullname)\AppData\Local\Microsoft\OneDrive"
        If (Test-Path $OneDrive) {
            $USR_ODexe = Get-ChildItem -Path "$OneDrive\*" -Include OneDriveSetup.exe -Recurse -ErrorAction SilentlyContinue
            If($USR_ODexe.Exists){
                Write-Log -Message "Found $($USR_ODexe.FullName), now attempting to uninstall $installTitle."
                Execute-ProcessAsUser -Path "$USR_ODexe" -Parameters "/uninstall"
                Start-Sleep -Seconds 5
            }
        }
    }
}
##############################################################################################
#   Download/Install OneDrive
##############################################################################################
$InstallFile = "$Path_4Log\onedrive-install.exe"
(New-Object Net.WebClient).DownloadFile("https://go.microsoft.com/fwlink/p/?LinkId=248256", $InstallFile)
Start-Process $InstallFile "/install"
Start-Sleep 10
Remove-Item $InstallFile -FOrce

##############################################################################################
#   Temporary Validation
##############################################################################################
# Register scheduled task to run at startup & delete itself
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal= New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType "ServiceAccount" -RunLevel "Highest"
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -command `"Unregister-ScheduledTask -TaskName $PackageName -Confirm:$false`""
$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $PackageName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Force

Stop-Transcript
