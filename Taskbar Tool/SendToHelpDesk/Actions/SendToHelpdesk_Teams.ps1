# YOUR Webhook URL
$WebHookURL = "https://xxxxx.webhook.office.com/webhookb2/someid..."
$WebHookURL = "https://movierush.webhook.office.com/webhookb2/9ff1ac22-827a-427c-80e4-5132de940a9f@acc82e89-04ec-460e-a300-f962ff2c4901/IncomingWebhook/7de373d46ff64653a30102cbcd4f95c4/e8618ce9-f443-4c76-8ad6-3bcc77c9fb82"

# Routine to gather device Informations
$UserObj = [Security.Principal.WindowsIdentity]::GetCurrent()
$Hostname = $env:COMPUTERNAME
$OSVersion = $((([Environment]::OSVersion).Version).ToString())
$Winver =  (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion).DisplayVersion
$UPTime = Set-ExecutionPolicy Bypass -Scope Process -Force; .\Device_Uptime.ps1
$lastUpdates = (( gwmi win32_quickfixengineering |sort installedon -desc )[0].InstalledOn).ToString("yyyy.MM.dd hh:mm")
$enrollment = if(Get-Item -Path HKLM:\SOFTWARE\Microsoft\Enrollments\* | Get-ItemProperty | Where-Object -FilterScript {$null -ne $_.UPN}){"Yes"}else{"No"}
$DeviceOwnership = switch(Get-ItemPropertyValue -Path HKLM:\SOFTWARE\Microsoft\Enrollments\Ownership -Name CorpOwned -ErrorAction SilentlyContinue){0{retun "Personal"}1{"Corporate"}$null{"Unkonw"}}
$imeStatus = If(Get-Service -Name "Microsoft Intune Management Extension" -ErrorAction SilentlyContinue | Where-Object {$_.Status -eq "Running"}) {"Running"}else{"Not Running"}

$GeneralInfo = @{
    "User" = "$($UserObj.Name)"
    "Hostname" = "$Hostname"
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

