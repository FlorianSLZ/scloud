$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Key = "HiberbootEnabled"
$Value = 0

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Key -ErrorAction Stop | Select-Object -ExpandProperty $Key
    If ($Registry -eq $Value){
        $Detection = $true
    } 
    exit 1
} 
Catch {
    exit 1
}

if($Detection -eq $true){
    Write-Host "Found it!"
}else{exit 1}