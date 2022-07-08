$PackageName = "PR4Business"

# check if running as system
function Test-RunningAsSystem {
	[CmdletBinding()]
	param()
	process {
		return [bool]($(whoami -user) -match "S-1-5-18")
	}
}

if(Test-RunningAsSystem){$Path_4Log = "$ENV:Programfiles\4net\EndpointManager"}
else{$Path_4Log = "$ENV:LOCALAPPDATA\4net\EndpointManager"}

Start-Transcript -Path "$Path_4Log\Log\uninstall\$PackageName-uninstall.log" -Force

$Task_Name = "$PackageName - $env:username"
Unregister-ScheduledTask -TaskName $Task_Name -Confirm:$false

# remove local Path
$Path_PR = "$Path_4Log\Data\PR_$PackageName"
Remove-Item -path $Path_PR -Recurse -Force

Stop-Transcript