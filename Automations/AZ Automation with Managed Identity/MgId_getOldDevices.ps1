# Connect to Microsoft Graph within Azure Automation (Microsoft Graph PowerShell v1)
Connect-AzAccount -Identity
$token = Get-AzAccessToken -ResourceUrl "https://graph.microsoft.com"
Connect-MgGraph -AccessToken $token.Token

# Define device age to include
$inactiveDays = "180"

# YOUR Webhook URL
$WebHookURL = "https://xxxx.webhook.office.com/someID..."

# Construct the Graph API request URI
$graphUri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices"
$filter = "lastSyncDateTime le $((Get-Date).AddDays(-$inactiveDays).ToString('yyyy-MM-ddTHH:mm:ssZ'))"
$uri = "$($graphUri)?`$filter=$filter"
$Method = "GET"

# Send the request and retrieve the devices
$response = Invoke-MgGraphRequest -Method $Method -uri $uri

# Create a report variable
$report = @()

# Build the report
foreach ($device in $response.value) {
    $deviceName = $device.deviceName
    $lastSyncDateTime = $device.lastSyncDateTime
    $deviceInfo = [PSCustomObject]@{
        DeviceName = $deviceName
        LastSyncDateTime = $lastSyncDateTime
    }
    $report += $deviceInfo
}

# Output the report
$report


if($report){

    # Message JSON 
    $Message_Json = [PSCustomObject][Ordered]@{
        "@type" = "MessageCard"
        "@context" = "<http://schema.org/extensions>"
        "summary" = "You have $($report.count) Inactive Devices which haven't have contatc in the last $inactiveDays"
        "themeColor" = '0078D7'
        "title" = "Inactive Devices ($($report.count))"
        "text" = "<h1>Inactive Devices for $inactiveDays+ days</h1>
        <pre>$($report | Format-Table DeviceName, LastSyncDateTime | Out-String)</pre>"
    } | ConvertTo-Json


    $parameters = @{
        "URI" = $WebHookURL
        "Method" = 'POST'
        "Body" = $Message_Json
        "ContentType" = 'application/json'
    }

    Invoke-RestMethod @parameters
}


