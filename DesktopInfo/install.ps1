$PackageName = "DesktopInfo"
$Version = 1
$Description = "Zeigt den Hostname auf dem Desktop, unabhängig vom Hintergrund."
$Prg_path = "$Env:Programfiles\DesktopInfo"

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-install.log" -Force

#Bestehenden Task beenden
taskkill /IM DesktopInfo64.exe /F
###########################################################################################
# Initial Setup und Variabeln
###########################################################################################
$scriptSaveName = "DesktopInfo.ps1"
$scriptPath = "$Prg_path\$scriptSaveName"
New-item -itemtype directory -force -path "$Prg_path"
Copy-item -path ".\DesktopInfo64.exe" -destination "$Prg_path\DesktopInfo64.exe"
Copy-item -path ".\hostname.ini" -destination "$Prg_path\hostname.ini"
Copy-item -path ".\DesktopInfo.ps1" -destination $scriptPath

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

$scriptSaveName = "$PackageName-VBSHelper.vbs"

$dummyScriptPath = $(Join-Path -Path $Prg_path -ChildPath $scriptSaveName)

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

$Path = "HKLM:\SOFTWARE\scloud\$PackageName"
$Key = "Version" 
$KeyFormat = "dword"
$Value = "$Version"

if(!(Test-Path $Path)){New-Item -Path $Path -Force}
if(!$Key){Set-Item -Path $Path -Value $Value
}else{Set-ItemProperty -Path $Path -Name $Key -Value $Value -Type $KeyFormat}

Stop-Transcript