try {
    if ($[Environment]::GetFolderPath("mydocuments") -like "*OneDrive*") {
        Write-Host "Remediation needed"
        exit 1
    }
    else {
        Write-Host "nothing to do"
        exit 0
    }    
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}