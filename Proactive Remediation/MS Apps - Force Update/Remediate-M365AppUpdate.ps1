$processArgs = @{
    'FilePath'     = "$env:ProgramFiles\Common Files\microsoft shared\ClickToRun\OfficeC2RClient.exe"
    'ArgumentList' = "/update user"
    'Wait'         = $true
}

if (-not (Test-Path $processArgs['FilePath'])) { throw "OfficeC2RClient.exe not found!" }
Start-Process @processArgs