# Check if the Windows Update service is running
$ServiceName = "wuauserv"
$Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

$output = @{
    WindowsUpdateService = if($Service.Status -eq "Running"){ $true }else{ $false }
}

return $output | ConvertTo-Json -Compress
