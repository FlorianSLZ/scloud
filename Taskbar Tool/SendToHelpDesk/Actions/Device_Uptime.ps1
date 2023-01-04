# Uptime Script by Damine: https://www.systanddeploy.com/2022/06/using-powershell-to-get-real-device.html

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
