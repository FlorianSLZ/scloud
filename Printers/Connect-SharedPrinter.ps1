$global:PackageName = "SharedPrinters"

$Path_4netIntune = "$Env:Programfiles\4net\EndpointManager"
Start-Transcript -Path "$Path_4netIntune\Log\$global:PackageName-mapping.log" -Force

###########################################################################################
# Input values 
$Prt_Server = "S-PRT01.scloud.work"
$Prt_Shares = "Printer 1. OG",
"Printer 2. OG",
"Printer 3. OG"

$Prt_REMOVEs = "Printer 1 OG SW"
$REMOVE_fromServer = $true #	$true: removes only printers from targeted Server, $false: remove all printer declared string in name
###########################################################################################


# check if running as system
function Test-RunningAsSystem {
	[CmdletBinding()]
	param()
	process {
		return [bool]($(whoami -user) -match "S-1-5-18")
	}
}

function Mapping-Printer ($Prt_Server, $Prt_Shares) {
	# process all Printers from $Prt_Server
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

function Remove-Printer ($Prt_Server, $Prt_REMOVEs){
	# Process printers from $Prt_REMOVEs
	foreach ($Prt_2remove in $Prt_REMOVEs) {

		if($REMOVE_fromServer -eq $true){$PrinterName = "\\$Prt_Server\$Prt_2remove"}
		else{$PrinterName = "*$Prt_2remove*"}
		# Check if Printer exists
		$checkPrinterExists = Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue
		if (!$checkPrinterExists) {
			Write-Host "$PrinterName, already removed!"
		}else{
			# try/catch removing printer
			try{
				Remove-Printer -Name $PrinterName -ErrorAction Stop
			}catch{
				Write-Host "Error removing $PrinterName:" -ForegroundColor Red
				Write-Host $_
			}
		}
	}
} 

Write-Output "Running as SYSTEM: $(Test-RunningAsSystem)"

# Processing Printers in user context
if (-not (Test-RunningAsSystem)) {

	Remove-Printer $Prt_Server $Prt_REMOVEs

	Mapping-Printer $Prt_Server $Prt_Shares
	
}

Stop-Transcript

# Create Sceduled Task as System
if (Test-RunningAsSystem) {

	Start-Transcript -Path $(Join-Path -Path "$Path_4netIntune\Log" -ChildPath "$global:PackageName-ScheduledTask.log")
	Write-Output "Running as System --> creating scheduled task which will run on user logon and network changes"

	# get this script content
	$currentScript = Get-Content -Path $($PSCommandPath)
	$schtaskScript = $currentScript[(0) .. ($currentScript.IndexOf("#!SCHTASKCOMESHERE!#") - 1)]
	$scriptSavePath = $(Join-Path -Path "$Path_4netIntune\Data" -ChildPath "printer-mapping")
	# Create Path if not exists
	if (-not (Test-Path $scriptSavePath)) {New-Item -ItemType Directory -Path $scriptSavePath -Force}
	# Save this file on local computer
	$PS_PathName = "$global:PackageName.ps1"
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

	# Register scheduled task to run for all users, trigers: logon and network changes
	$schtaskName = "$global:PackageName"
	$schtaskDescription = "Map network printers on logon and network change. "

	$trigger1 = New-ScheduledTaskTrigger -AtLogOn

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
	$action = New-ScheduledTaskAction -Execute $(Join-Path $env:SystemRoot -ChildPath "System32\wscript.exe") -Argument "`"$vbsScriptPath`" `"$scriptPath`""
	$settings= New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
	$null = Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger1,$trigger2,$trigger3 -Action $action -Principal $principal -Settings $settings -Description $schtaskDescription -Force
	
	Start-ScheduledTask -TaskName $schtaskName
	
	Stop-transcript

}
