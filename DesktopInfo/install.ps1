$PackageName = "DesktopInfo"
$Description = "Zeigt den Hostname auf dem Desktop, unabhängig vom Hintergrund."

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-install.log" -Force

#Bestehenden Task beenden
taskkill /IM DesktopInfo64.exe /F
###########################################################################################
# Initial Setup und Variabeln
###########################################################################################
$scriptSavePath = "C:\Program Files\4net\EndpointManager\Program\DesktopInfo"
$scriptSavePathName = "DesktopInfo.ps1"
$scriptPath = "$scriptSavePath\$scriptSavePathName"
New-item -itemtype directory -force -path "$Path_4netIntune\Program\DesktopInfo"
Copy-item -path "DesktopInfo64.exe" -destination "$Path_4netIntune\Program\DesktopInfo\DesktopInfo64.exe"
Copy-item -path "hostname.ini" -destination "$Path_4netIntune\Program\DesktopInfo\hostname.ini"
Copy-item -path "DesktopInfo.ps1" -destination $scriptPath

###########################################################################################
# Create dummy vbscript to hide PowerShell Window popping up at logon
###########################################################################################

$vbsDummyScript = "
Dim shell,fso,file

Set shell=CreateObject(`"WScript.Shell`")
Set fso=CreateObject(`"Scripting.FileSystemObject`")

strPath=WScript.Arguments.Item(0)

If fso.FileExists(strPath) Then
	set file=fso.GetFile(strPath)
	strCMD=`"powershell -nologo -executionpolicy ByPass -command `" & Chr(34) & `"&{`" &_
	file.ShortPath & `"}`" & Chr(34)
	shell.Run strCMD,0
End If
"

$scriptSavePathName = "$PackageName-VBSHelper.vbs"

$dummyScriptPath = $(Join-Path -Path $scriptSavePath -ChildPath $scriptSavePathName)

$vbsDummyScript | Out-File -FilePath $dummyScriptPath -Force

$wscriptPath = Join-Path $env:SystemRoot -ChildPath "System32\wscript.exe"

###########################################################################################
# Register a scheduled task to run for all users and execute the script on logon
###########################################################################################

$schtaskName = $PackageName
$schtaskDescription = $Description

$trigger = New-ScheduledTaskTrigger -AtLogOn

#Execute task in users context
$principal= New-ScheduledTaskPrincipal -GroupId "S-1-5-32-545" -Id "Author"

#call the vbscript helper and pass the PosH script as argument
$action = New-ScheduledTaskAction -Execute $wscriptPath -Argument "`"$dummyScriptPath`" `"$scriptPath`""

$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

$null=Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force

Start-ScheduledTask -TaskName $schtaskName

Stop-Transcript