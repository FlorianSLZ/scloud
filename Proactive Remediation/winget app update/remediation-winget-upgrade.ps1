Param(
    [parameter(Mandatory=$false)]
    [String[]]
    $app_2upgrade = "WINGETPROGRAMID",

	[parameter(Mandatory=$false)]
    [String[]]
	$version = "auto"
)

try{
    # resolve and navigate to winget
    $Path_WingetAll = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    if($Path_WingetAll){$Path_Winget = $Path_WingetAll[-1].Path}
    cd $Path_Winget

    # upgrade command
    .\winget.exe upgrade --exact $app_2upgrade --silent --force --accept-package-agreements --accept-source-agreements
    exit 0

}catch{
    Write-Error "Error while installing upgarde for: $app_2upgrade"
    exit 1
}
