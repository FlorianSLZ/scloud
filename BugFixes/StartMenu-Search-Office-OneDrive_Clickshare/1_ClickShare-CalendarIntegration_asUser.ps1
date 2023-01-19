# Process name
$process = "clickshare_native"

# Stop process if running
$activeprocess = Get-Process -ProcessName $process -ErrorAction SilentlyContinue
if ($activeprocess) {
    Stop-Process -ProcessName $process -Force
} 

# Set Calendar Integration to False
if ((Test-Path -LiteralPath "HKCU:\SOFTWARE\Barco\ClickShare Client") -ne $true) { New-Item "HKCU:\SOFTWARE\Barco\ClickShare Client" -force -ea SilentlyContinue };
if ((Test-Path -LiteralPath "HKCU:\SOFTWARE\Barco\ClickShare Client\calendar") -ne $true) { New-Item "HKCU:\SOFTWARE\Barco\ClickShare Client\calendar" -force -ea SilentlyContinue };
if ((Test-Path -LiteralPath "HKCU:\SOFTWARE\Barco\ClickShare Client\WindowPosition") -ne $true) { New-Item "HKCU:\SOFTWARE\Barco\ClickShare Client\WindowPosition" -force -ea SilentlyContinue };
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Barco\ClickShare Client' -Name 'CalendarIntegrationImprovement' -Value 'done' -PropertyType String -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Barco\ClickShare Client' -Name 'CalendarIntegration' -Value 'false' -PropertyType String -Force -ea SilentlyContinue;
