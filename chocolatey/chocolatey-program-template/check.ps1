$ProgramName = "ChocoProgramID"


$ChocoPrg_Existing = C:\ProgramData\chocolatey\choco.exe list --localonly
    if ($ChocoPrg_Existing -like "*$ProgramName*"){
    Write-Host "Found it!"
}