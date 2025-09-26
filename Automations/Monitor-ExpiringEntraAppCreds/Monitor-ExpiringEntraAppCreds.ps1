<#
.SYNOPSIS
  Azure Automation Runbook: Report Entra application credentials (secrets & certificates) 
  expiring in the next N days, and email results via Microsoft Graph.

.DESCRIPTION
  - Authenticates with Microsoft Graph using Managed Identity (`Connect-MgGraph -Identity`).
  - Retrieves all Entra applications and checks their passwordCredentials (secrets) 
    and keyCredentials (certificates).
  - Detects credentials that are expired or expiring within the next N days (default: 30).
  - Sends a formatted HTML email with a summary table directly via Graph 
    (no SMTP, no CSV attachments).
  - Designed for PowerShell 7 in Azure Automation.

.AUTHENTICATION
  In Azure Automation:
    Connect-MgGraph -Identity

  For local testing as a user (delegated permissions, interactive login):
    Connect-MgGraph -Scopes "Application.Read.All","Mail.Send"

.REQUIREMENTS
  - Azure Automation account with System-Assigned Managed Identity enabled.
  - Microsoft.Graph.Authentication module imported in the Runbook.
  - The Managed Identity must have the following **Application permissions** in Graph:
        * Application.Read.All
        * Mail.Send
  - A mailbox must exist for the `-FromUserPrincipalName` parameter. 
    The mail will be sent from this account using Graph.

.PARAMETER To
  One or more recipient email addresses.

.PARAMETER FromUserPrincipalName
  The mailbox to send the email from (e.g., reports@contoso.com).

.PARAMETER DaysAhead
  Number of days to look ahead for expiring credentials. Default: 30.

.PARAMETER SaveToSentItems
  Boolean flag to determine if the sent email should be stored in Sent Items. Default: $true.

.EXAMPLE
  .\Monitor-ExpiringEntraAppCreds.ps1 -To "itops@contoso.com","secops@contoso.com" `
                -FromUserPrincipalName "reports@contoso.com" `
                -DaysAhead 45

.NOTES
  Author: Florian Salzmann (@FlorianSLZ)
  Blog:   https://scloud.work
  Version: 1.2 (logging)
  Date:    2025-09-26
#>

param(
  [Parameter(Mandatory = $true)]
  [string]$To,

  [Parameter(Mandatory = $true)]
  [string]$FromUserPrincipalName,

  [ValidateRange(1,365)]
  [int]$DaysAhead = 30,

  [bool]$SaveToSentItems = $true
)

# --- Timing ---
$sw = [System.Diagnostics.Stopwatch]::StartNew()

# Connect with Managed Identity
Write-Output "[$(Get-Date -Format o)] Connecting to Microsoft Graph (Managed Identity)..."
Connect-MgGraph -Identity -NoWelcome
Write-Output "[$(Get-Date -Format o)] Connected."

# Helper: page all results (with minimal paging logs)
function Invoke-GraphGetAll {
  param([Parameter(Mandatory=$true)][string]$Url)
  $all = @()
  $next = $Url
  $page = 0
  do {
    $page++
    Write-Output "[$(Get-Date -Format o)] Fetching page $page : $next"
    $r = Invoke-MgGraphRequest -Method GET -Uri $next
    $count = @($r.value).Count
    Write-Output "[$(Get-Date -Format o)] Page $page returned $count item(s)."
    if ($r.value) { $all += $r.value }
    $next = $r.'@odata.nextLink'
  } while ($next)
  Write-Output "[$(Get-Date -Format o)] Completed paging. Total items: $($all.Count)"
  $all
}

$now  = [DateTimeOffset]::UtcNow
$edge = $now.AddDays($DaysAhead)
Write-Output "[$(Get-Date -Format o)] Window: now=$($now.UtcDateTime.ToString('u')) edge=$($edge.UtcDateTime.ToString('u')) (DaysAhead=$DaysAhead)."

# Pull all applications with needed fields
$appsUrl = "https://graph.microsoft.com/v1.0/applications`?`$select=id,appId,displayName,passwordCredentials,keyCredentials&`$top=999"
Write-Output "[$(Get-Date -Format o)] Retrieving applications..."
$apps = Invoke-GraphGetAll -Url $appsUrl
Write-Output "[$(Get-Date -Format o)] Applications fetched: $($apps.Count)"

# Collect expiring/expired credentials
$findings = New-Object System.Collections.Generic.List[object]
$processed = 0

foreach ($app in $apps) {
  $processed++
  if (($processed % 250) -eq 0) {
    Write-Output "[$(Get-Date -Format o)] Processed $processed / $($apps.Count) applications..."
  }

  # Secrets
  foreach ($s in ($app.passwordCredentials | ForEach-Object { $_ })) {
    if ($s -and $s.endDateTime) {
      $end = [DateTimeOffset]$s.endDateTime
      if ($end -le $edge) {
        $findings.Add([pscustomobject]@{
          ApplicationName = $app.displayName
          ApplicationId   = $app.appId
          ObjectId        = $app.id
          CredentialType  = "Secret"
          KeyId           = $s.keyId
          EndUtc          = $end.UtcDateTime.ToString("u")
          DaysLeft        = [math]::Round(($end - $now).TotalDays, 1)
          Status          = if ($end -lt $now) { "Expired" } else { "Expiring" }
        })
      }
    }
  }
  # Certificates
  foreach ($c in ($app.keyCredentials | ForEach-Object { $_ })) {
    if ($c -and $c.endDateTime) {
      $end = [DateTimeOffset]$c.endDateTime
      if ($end -le $edge) {
        $findings.Add([pscustomobject]@{
          ApplicationName = $app.displayName
          ApplicationId   = $app.appId
          ObjectId        = $app.id
          CredentialType  = "Certificate"
          KeyId           = $c.keyId
          EndUtc          = $end.UtcDateTime.ToString("u")
          DaysLeft        = [math]::Round(($end - $now).TotalDays, 1)
          Status          = if ($end -lt $now) { "Expired" } else { "Expiring" }
        })
      }
    }
  }
}

Write-Output "[$(Get-Date -Format o)] Credential scan complete."
Write-Output "[$(Get-Date -Format o)] Findings total: $($findings.Count)"
$expiredCount  = ($findings | Where-Object { $_.Status -eq "Expired" }).Count
$expiringCount = ($findings | Where-Object { $_.Status -eq "Expiring" }).Count
Write-Output "[$(Get-Date -Format o)] Breakdown: Expired=$expiredCount, Expiring=$expiringCount"

# Build HTML table (no attachment)
$style = @"
<style>
  body { font-family: Segoe UI, Arial, sans-serif; font-size: 13px; }
  .hdr { font-size: 16px; font-weight: 600; margin-bottom: 8px; }
  .muted { color:#666; }
  table { border-collapse: collapse; width: 100%; margin-top: 8px; }
  th, td { border: 1px solid #ddd; padding: 6px 8px; text-align: left; }
  th { background: #f5f5f5; }
  .expired { background:#fde7e9; }
  .expiring { background:#fff4ce; }
  .badge { padding:2px 6px; border-radius:4px; font-size:12px; }
</style>
"@

if ($findings.Count -eq 0) {
  $htmlBody = @"
$style
<div class="hdr">Entra application credentials report</div>
<p>No secrets or certificates are expiring in the next <b>$DaysAhead</b> days (as of $($now.UtcDateTime.ToString("u"))).</p>
"@
} else {
  $sorted = $findings | Sort-Object Status, DaysLeft, ApplicationName
  $rows = ($sorted | ForEach-Object {
    $cls = if ($_.Status -eq "Expired") { "expired" } else { "expiring" }
    "<tr class='$cls'><td>$($_.ApplicationName)</td><td>$($_.ApplicationId)</td><td>$($_.ObjectId)</td><td>$($_.CredentialType)</td><td>$($_.KeyId)</td><td>$($_.EndUtc)</td><td align='right'>$($_.DaysLeft)</td><td><span class='badge'>$($_.Status)</span></td></tr>"
  }) -join "`n"

  $htmlBody = @"
$style
<div class="hdr">Entra application credentials report</div>
<p>Found <b>$($sorted.Count)</b> credentials expiring by <b>$($edge.UtcDateTime.ToString("u"))</b>
  (<span class="muted">$expiredCount expired, $expiringCount expiring</span>).</p>
<table>
  <thead>
    <tr>
      <th>Application</th>
      <th>App ID</th>
      <th>Object ID</th>
      <th>Type</th>
      <th>Key ID</th>
      <th>End (UTC)</th>
      <th>Days Left</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody>
    $rows
  </tbody>
</table>
<p class="muted">Generated: $($now.UtcDateTime.ToString("u"))</p>
"@
}

# Build and send email via Graph (application permissions)
$toRecipients = @()
foreach ($addr in $To) {
  if (-not [string]::IsNullOrWhiteSpace($addr)) {
    $toRecipients += @{ emailAddress = @{ address = $addr.Trim() } }
  }
}

$subject = "[Entra] App credentials $($findings.Count) expiring in next $DaysAhead days"
Write-Output "[$(Get-Date -Format o)] Preparing email."
Write-Output "[$(Get-Date -Format o)] From: $FromUserPrincipalName"
Write-Output "[$(Get-Date -Format o)] To:   $($To -join ', ')"
Write-Output "[$(Get-Date -Format o)] Subj: $subject"

$mailBody = @{
  message = @{
    subject     = $subject
    body        = @{ contentType = "HTML"; content = $htmlBody }
    toRecipients= $toRecipients
  }
  saveToSentItems = [bool]$SaveToSentItems
}

$sendUrl = "https://graph.microsoft.com/v1.0/users/$([uri]::EscapeDataString($FromUserPrincipalName))/sendMail"
Invoke-MgGraphRequest -Method POST -Uri $sendUrl -Body ($mailBody | ConvertTo-Json -Depth 10)
Write-Output "[$(Get-Date -Format o)] Email sent."

$sw.Stop()
Write-Output "[$(Get-Date -Format o)] DONE. Findings=$($findings.Count) | Expired=$expiredCount | Expiring=$expiringCount | Runtime=$($sw.Elapsed.ToString())"
