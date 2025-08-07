try {
    Write-Output "Fetching IANA time zone from ipinfo.io..."
    $ianaTz = (Invoke-RestMethod -Uri "http://ipinfo.io/json").timezone
    if (-not $ianaTz) {
        throw "Could not retrieve IANA time zone from ipinfo.io."
    }
    Write-Output "Detected IANA Time Zone: $ianaTz"

    Write-Output "Downloading custom XML mapping..."
    $xmlUrl = "https://raw.githubusercontent.com/FlorianSLZ/scloud/refs/heads/main/scripts/Set-TimeZoneByIPAddress/windowsZones.xml"
    [xml]$windowsZones = Invoke-RestMethod -Uri $xmlUrl
    if (-not $windowsZones) {
        throw "Failed to download or parse the XML mapping file."
    }

    Write-Output "Searching for matching mapping..."
    $mapping = $windowsZones.supplementalData.windowsZones.mapTimezones.mapZone | Where-Object {
        $_.type -split ' ' -contains $ianaTz
    }

    if (-not $mapping) {
        throw "No mapping found for IANA time zone: $ianaTz"
    }

    $windowsTZ = $mapping.other
    Write-Output "Mapped to Windows Time Zone: $windowsTZ"

    try {
        Write-Output "Setting Windows time zone using Set-TimeZone..."
        Set-TimeZone -Id $windowsTZ
        Write-Output "Successfully set Windows Time Zone: $windowsTZ"
    } catch {
        Write-Error "Set-TimeZone failed. "
    }

} catch {
    Write-Error "Failed to set Windows time zone: $_"
}
