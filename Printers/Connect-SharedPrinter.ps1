$PackageName = "SharedPrinters"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-mapping.log" -Force

# Input values 
$PrtServer = "S-PRT01.scloud.work"
$Printers_Shares = "Printer 1. OG","Printer 2. OG"
$Printers_REMOVE = "Printer 1 OG SW"

# check if running as system
function Test-RunningAsSystem {
	[CmdletBinding()]
	param()
	process {
		return [bool]($(whoami -user) -match "S-1-5-18")
	}
}

Write-Output "Running as SYSTEM: $(Test-RunningAsSystem)"

# Removing/Mapping printers (as User / no system context)
if (-not (Test-RunningAsSystem)) {

	# Process printers from $Printers_REMOVE
	foreach ($PrinterRemove in $Printers_REMOVE) {
		$PrinterShareName = "\\$PrtServer\$PrinterRemove"
		# Check if Printer exists
		$checkPrinterExists = Get-Printer -Name $PrinterRemove -ErrorAction SilentlyContinue
		if (!$checkPrinterExists) {
			Write-Host "$PrinterRemove, already removed!"
		}else{
			# try/catch removing printer
			try{
				Remove-Printer -Name $PrinterRemove -ErrorAction Stop
			}catch{
				Write-Host "Error removing $PrinterRemove:" -ForegroundColor Red
				Write-Host $_
			}
		}
	}


	# process all Printers
	foreach ($Printer in $Printers_Shares) {
		$PrinterShareName = "\\$PrtServer\$Printer"
		# Check if Printer exists
		$checkPrinterExists = Get-Printer -Name $PrinterShareName -ErrorAction SilentlyContinue
		if ($checkPrinterExists) {
			Write-Host "Already installed!"
		}else{
			# try/catch adding printer
			try{
				Add-Printer -ConnectionName $PrinterShareName -ErrorAction Stop
			}catch{
				Write-Host "Error adding $PrinterRemove:" -ForegroundColor Red
				Write-Host $_
			}
		}
	}
}

Stop-transcript

# If this script running as system scheduled task is created
if (Test-RunningAsSystem) {

	Start-Transcript -Path $(Join-Path -Path "$Path_4netIntune\Log" -ChildPath "$PackageName-ScheduledTask.log")
	Write-Output "Running as System --> creating scheduled task which will run on user logon and network changes"

	$currentScript = Get-Content -Path $($PSCommandPath)

	$schtaskScript = $currentScript[(0) .. ($currentScript.IndexOf("#!SCHTASKCOMESHERE!#") - 1)]

	$scriptSavePath = $(Join-Path -Path "$Path_4netIntune\Data" -ChildPath "intune-printer-mapping")

	if (-not (Test-Path $scriptSavePath)) {

		New-Item -ItemType Directory -Path $scriptSavePath -Force
	}

	$scriptSavePathName = "$PackageName.ps1"

	$scriptPath = $(Join-Path -Path $scriptSavePath -ChildPath $scriptSavePathName)

	$schtaskScript | Out-File -FilePath $scriptPath -Force

	# Dummy vbscript to hide PowerShell Window popping up at task execution
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

	# Register a scheduled task to run for all users and execute the script on logon
	$schtaskName = "$PackageName"
	$schtaskDescription = "Map network printers. Task created with intune."

	$trigger = New-ScheduledTaskTrigger -AtLogOn

	$class = cimclass MSFT_TaskEventTrigger root/Microsoft/Windows/TaskScheduler
	$trigger2 = $class | New-CimInstance -ClientOnly
	$trigger2.Enabled = $True
	$trigger2.Subscription = '<QueryList><Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"><Select Path="Microsoft-Windows-NetworkProfile/Operational">*[System[Provider[@Name=''Microsoft-Windows-NetworkProfile''] and EventID=10002]]</Select></Query></QueryList>'
	
	$trigger3 = $class | New-CimInstance -ClientOnly
	$trigger3.Enabled = $True
	$trigger3.Subscription = '<QueryList><Query Id="0" Path="Microsoft-Windows-NetworkProfile/Operational"><Select Path="Microsoft-Windows-NetworkProfile/Operational">*[System[Provider[@Name=''Microsoft-Windows-NetworkProfile''] and EventID=4004]]</Select></Query></QueryList>'
	
	# Execute as user
	$principal= New-ScheduledTaskPrincipal -GroupId "S-1-5-32-545" -Id "Author"
	
	# call the vbscript helper and pass the PosH script as argument
	$action = New-ScheduledTaskAction -Execute $wscriptPath -Argument "`"$dummyScriptPath`" `"$scriptPath`""
	
	$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
	
	$null = Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger,$trigger2,$trigger3 -Action $action  -Principal $principal -Settings $settings -Description $schtaskDescription -Force
	
	Start-ScheduledTask -TaskName $schtaskName
	
	Stop-transcript

	}
