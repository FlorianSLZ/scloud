$ProgramName = "Chocolatey"
$Version = "2.0"

$localprograms = C:\ProgramData\chocolatey\choco.exe list --exact $ProgramName -r
$name, $version_local = $localprograms -split '\|'

if ($name -and ($version_local -ge $Version)){
    Write-Host "Found it!"
}

