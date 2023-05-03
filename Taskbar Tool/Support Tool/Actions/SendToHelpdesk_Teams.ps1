# YOUR Webhook URL
$WebHookURL = "https://xxxxx.webhook.office.com/webhookb2/someid..."

Function Get_DeviceUpTime
	{
    # https://www.systanddeploy.com/2022/06/using-powershell-to-get-real-device.html
		param(
		[Switch]$Show_Days,
		[Switch]$Show_Uptime			
		)		
		
		$Last_reboot = Get-ciminstance Win32_OperatingSystem | Select -Exp LastBootUpTime
		$Check_FastBoot = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -ea silentlycontinue).HiberbootEnabled 
		If(($Check_FastBoot -eq $null) -or ($Check_FastBoot -eq 0))
			{
				$Boot_Event = Get-WinEvent -ProviderName 'Microsoft-Windows-Kernel-Boot'| where {$_.ID -eq 27 -and $_.message -like "*0x0*"}
				If($Boot_Event -ne $null)
					{
						$Last_boot = $Boot_Event[0].TimeCreated
					}
			}
		ElseIf($Check_FastBoot -eq 1)
			{
				$Boot_Event = Get-WinEvent -ProviderName 'Microsoft-Windows-Kernel-Boot'| where {$_.ID -eq 27 -and $_.message -like "*0x1*"}
				If($Boot_Event -ne $null)
					{
						$Last_boot = $Boot_Event[0].TimeCreated
					}
			}		
			
		If($Last_boot -eq $null)
			{
				$Uptime = $Uptime = $Last_reboot
			}
		Else
			{
				If($Last_reboot -ge $Last_boot)
					{
						$Uptime = $Last_reboot
					}
				Else
					{
						$Uptime = $Last_boot
					}
			}
		
		If($Show_Days)
			{
				$Current_Date = get-date
				$Diff_boot_time = $Current_Date - $Uptime
				$Boot_Uptime_Days = $Diff_boot_time.Days	
				$Real_Uptime = $Boot_Uptime_Days
			}
		ElseIf($Show_Uptime)
			{
				$Real_Uptime = $Uptime
				
			}
		ElseIf(($Show_Days -eq $False) -and ($Show_Uptime -eq $False))
			{
				$Real_Uptime = $Uptime				
			}			
		Return "$Real_Uptime"
	}

# Routine to gather device Informations
$UserObj = [Security.Principal.WindowsIdentity]::GetCurrent()
$Hostname = $env:COMPUTERNAME
$SerialNumber = $(Get-WmiObject win32_bios).Serialnumber
$OSVersion = $((([Environment]::OSVersion).Version).ToString())
$Winver =  (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion
$UPTime = Get_DeviceUpTime
$lastUpdates = (( gwmi win32_quickfixengineering |sort installedon -desc )[0].InstalledOn).ToString("yyyy.MM.dd hh:mm")
$enrollment = if(Get-Item -Path HKLM:\SOFTWARE\Microsoft\Enrollments\* | Get-ItemProperty | Where-Object -FilterScript {$null -ne $_.UPN}){"Yes"}else{"No"}
$DeviceOwnership = switch(Get-ItemPropertyValue -Path HKLM:\SOFTWARE\Microsoft\Enrollments\Ownership -Name CorpOwned -ErrorAction SilentlyContinue){0{retun "Personal"}1{"Corporate"}$null{"Unkonw"}}
$imeStatus = If(Get-Service -Name "Microsoft Intune Management Extension" -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq "Running"}) {"Running"}else{"Not Running"}

$GeneralInfo = @{
    "User" = "$($UserObj.Name)"
    "Hostname" = "$Hostname"
	"Serial number" = "$SerialNumber"
    "Uptime" = "$UPTime"
    "OS" = "$OSVersion / $Winver"
    "enrollment" = "$enrollment"
    "Device Ownership" = "$DeviceOwnership"
    "IME" = "$imeStatus"
} 

$NetworkInfo = Get-NetIPAddress | Select IPAddress, InterfaceAlias, PrefixOrigin

$GroupMemberships = $UserObj.Groups | foreach-object {
 $_.Translate([Security.Principal.NTAccount])
} 

# Message JSON 
$Message_Json = [PSCustomObject][Ordered]@{
    "@type" = "MessageCard"
    "@context" = "<http://schema.org/extensions>"
    "summary" = "HelpdeskInfo: $Hostname / $env:USERNAME"
    "themeColor" = '0078D7'
	"title" = "$Hostname / $env:USERNAME"
    "text" = "<h1>General Informations</h1>
    <pre>$($GeneralInfo | Format-Table Name, Value -HideTableHeaders | Out-String)</pre>
    <br>
    <h1>Network Informations</h1>
    <pre>$($($NetworkInfo | Format-List * -Force | Out-String) -join '<br>')</pre>
    <br>
    <h1>Local Group Memberships ($env:USERNAME)</h1>
    <pre>$($GroupMemberships | Format-table value -HideTableHeaders -Force | Out-String)</pre>
    
    "
} | ConvertTo-Json






$parameters = @{
	"URI" = $WebHookURL
	"Method" = 'POST'
	"Body" = $Message_Json
	"ContentType" = 'application/json'
}

Invoke-RestMethod @parameters

