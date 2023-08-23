<#PSScriptInfo
  
.VERSION 1.0
.GUID b72d1888-1997-4812-b53c-be274a6b80cc
.AUTHOR Florian Salzmann
.COMPANYNAME scloud.work
.COPYRIGHT
.TAGS Windows Autopilot
.LICENSEURI https://github.com/FlorianSLZ/scloud/blob/main/LICENSE.md
.PROJECTURI https://scloud.work/Get-AutopilotProfileInfo
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
    Version 1.0: Original published version.
 
#>

<#
.SYNOPSIS
Find out in which tenant a device is registered with Windows Autopilot.  

.DESCRIPTION
Find out in which tenant a device is registered with Windows Autopilot.  
The details are stored in the device's registry (if the Autopilot profile has been downloaded). 

.PARAMETER All
Switch to get extended infos from the Profile

.EXAMPLE
.\Get-AutopilotProfileInfo.ps1
 
.EXAMPLE
.\Get-AutopilotProfileInfo.ps1 -All
  
#>

param(
    [parameter(Mandatory = $false, HelpMessage = "Switch to get extended infos from the Profile")]
    [ValidateNotNullOrEmpty()]
    [switch]$All
)


$onMS_Path = "HKLM:\SOFTWARE\Microsoft\Provisioning\Diagnostics\Autopilot"
$onMS_Key = "CloudAssignedTenantDomain" 

$Policy_Path = "HKLM:\SOFTWARE\Microsoft\Provisioning\AutopilotPolicyCache"
$Policy_Key = "PolicyJsonCache" 


Try {
    if (Test-Path $onMS_Path) {
        $RegResult = Get-ItemProperty $onMS_Path -Name $onMS_Key -ErrorAction Stop | Select-Object -ExpandProperty $onMS_Key
        Write-Host "This Devices is registerd with the onMicorsft Domain: "
		Write-Host "$($RegResult)`n" -ForegroundColor Green

    }
    else {
        Write-Host "No Autopilot Infos found!"
    }

	if($All){
		if (Test-Path $Policy_Path) {
			$Policy_RegResult = Get-ItemProperty $Policy_Path -Name $Policy_Key -ErrorAction Stop | Select-Object -ExpandProperty $Policy_Key | ConvertFrom-Json
			Write-Host "`nMore Infos about this devices Atopilot profile:"
			$Policy_RegResult | fl

		}
		else {
			Write-Host "No extended Autopilot Infos found!"
		}
	}
}
Catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
}
