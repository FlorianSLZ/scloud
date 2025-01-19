# Example script with multiple outputs
$PSlogicOutput1 = $true  # Replace with logic for Check1
$PSlogicOutput2 = 3     # Replace with logic for Check2

$output = @{
    Check1 = $PSlogicOutput1
    Check2 = $PSlogicOutput2
}

return $output | ConvertTo-Json -Compress