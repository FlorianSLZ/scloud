# Check if a specific file exists
$FilePath = "C:\ProgramData\CustomApp\config.xml"

$output = @{
    FileCheck = if (Test-Path $FilePath) { $true } else { $false }
}

return $output | ConvertTo-Json -Compress