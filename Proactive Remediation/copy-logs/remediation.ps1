$Logs = "$env:ProgramData\Logs\Software", "C:\Users\*\AppData\Local\_MEM\Log"
$mode = "move" # move or copy
# PSADT user logs: "$env:ProgramData\Logs\Software"
$IMElogs = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\"

try {
    $logfiles = @()
    foreach($path in $Logs){
        $logfiles += Get-ChildItem $path -Recurse -Filter "*.log"
    }

    Switch ($mode){
        move { $logfiles | Move-Item -Destination $IMElogs -Force }
        copy { $logfiles | Copy-Item -Destination $IMElogs -Force }
    }
} 
catch {
    Write-Error "Error Processing detection: $_"
    exit 1
}
