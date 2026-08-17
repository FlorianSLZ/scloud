<#
.DESCRIPTION
    Re-Installation / Repair for Comapny Portal App
    
.NOTES
    Run this script as System/Device in 64 context.

#>


Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OnDemand_CompanyPortal-Repair.log" -Force


$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

& $winget_exe uninstall 9WZDNCRFJ3PZ --silent --accept-source-agreements
& $winget_exe install --exact --id 9WZDNCRFJ3PZ --silent --accept-package-agreements --accept-source-agreements

& $winget_exe list "Company Portal"


Stop-Transcript | Out-Null
