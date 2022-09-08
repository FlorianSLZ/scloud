Param(
    [parameter(Mandatory=$false)]
    [String[]]
    $app_2upgrade = "WINGETPROGRAMID",

	[parameter(Mandatory=$false)]
    [String[]]
	$version = "auto"
)

# resolve and navigate to winget
$Path_WingetAll = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if($Path_WingetAll){$Path_Winget = $Path_WingetAll[-1].Path}
cd $Path_Winget

if ($(.\winget upgrade) -like "* $app_2upgrade *") {
	Write-Host "Upgrade aviable for: $app_2upgrade"
	exit 1 # upgrade aviable, remediation needed
}
else {
		Write-Host "No Upgrade aviable"
		exit 0 # no upgared, no action needed
}
