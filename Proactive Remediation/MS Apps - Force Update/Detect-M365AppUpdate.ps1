# See Microsoft 365 Apps Version history https://learn.microsoft.com/en-us/officeupdates/update-history-microsoft365-apps-by-date#version-history

$targetVersions = @{
    'CurrentChannel'                        = [System.Version]::Parse('16.0.16130.20306')
    'MonthlyEnterpriseChannel1'             = [System.Version]::Parse('16.0.16026.20238')
    'MonthlyEnterpriseChannel2'             = [System.Version]::Parse('16.0.15928.20298')
    'Semi-AnnualEnterpriseChannel(Preview)' = [System.Version]::Parse('16.0.16130.20306')
    'Semi-AnnualEnterpriseChannel1'         = [System.Version]::Parse('16.0.15601.20578')
    'Semi-AnnualEnterpriseChannel2'         = [System.Version]::Parse('16.0.14931.20944')
    'CurrentChannel(Preview)'               = [System.Version]::Parse('16.0.16227.20094')
}

$configuration = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration" 
$displayVersion = $null

if ( [System.Version]::TryParse($configuration.VersionToReport, $([ref]$displayVersion))) {

    Write-Output ("Discovered VersionToReport {0}" -f $displayVersion.ToString())

    $targetVersion = $targetVersions.Values | Where-Object { $_.Build -eq $displayVersion.Build } | Select-Object -Unique -First 1

    Write-Output ("Mapped minimum target version to {0}" -f $targetVersion.ToString())

    if ($null -eq $targetVersion -or $displayVersion -lt $targetVersion) {
        Write-Output ("Current Office365 Version {0} is lower than specified target version {1}" -f $displayVersion.ToString(), $targetVersion.ToString())
        Write-Output "Triggering remediation..."
        Exit 1
    } else {
        Write-Output ("Current Office365 Version {0} matches specified target version {1}" -f $displayVersion.ToString(), $targetVersion.ToString())
        Exit 0
    }
} else {
    throw "Unable to parse VersionToReport for Office"
}