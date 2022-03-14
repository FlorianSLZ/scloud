$PackageName = "SharedPrinters"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$PackageName-mapping.log" -Force

# Input values 
$Prt_Server = "S-PRT01.scloud.work"
$Prt_Shares = "Printer 1. OG","Printer 2. OG"
$Prt_REMOVEs = "Printer 1 OG SW"

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

	# Process printers from $Prt_REMOVEs
	foreach ($PrinterRemove in $Prt_REMOVEs) {
		$PrinterShareName = "\\$Prt_Server\$PrinterRemove"
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
	foreach ($Printer in $Prt_Shares) {
		$PrinterShareName = "\\$Prt_Server\$Printer"
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

	$scriptSavePath = $(Join-Path -Path "$Path_4netIntune\Data" -ChildPath "printer-mapping")

	if (-not (Test-Path $scriptSavePath)) {

		New-Item -ItemType Directory -Path $scriptSavePath -Force
	}

	$PS_PathName = "$PackageName.ps1"

	$ps_ScriptPath = $(Join-Path -Path $scriptSavePath -ChildPath $PS_PathName)

	$schtaskScript | Out-File -FilePath $ps_ScriptPath -Force

	# Dummy vbscript to hide PowerShell Window popping up at task execution
	$vbsHiddenPS = "
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

	$vbs_Name = "run-ps-hidden.vbs"

	$vbs_ScriptPath = $(Join-Path -Path $scriptSavePath -ChildPath $vbs_Name)

	$vbsHiddenPS | Out-File -FilePath $vbs_ScriptPath -Force

	$wscriptPath = Join-Path $env:SystemRoot -ChildPath "System32\wscript.exe"

	# Register a scheduled task to run for all users and execute the script on logon
	$schtaskName = "$PackageName"
	$schtaskDescription = "Map network printers on logon and network change. "

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
	$action = New-ScheduledTaskAction -Execute $wscriptPath -Argument "`"$vbsScriptPath`" `"$scriptPath`""
	
	$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
	
	$null = Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger,$trigger2,$trigger3 -Action $action  -Principal $principal -Settings $settings -Description $schtaskDescription -Force
	
	Start-ScheduledTask -TaskName $schtaskName
	
	Stop-transcript

	}
