$Logs = "$env:ProgramData\Logs\Software", "C:\Users\*\AppData\Local\_MEM\Log"
# PSADT user logs: "$env:ProgramData\Logs\Software"

try {
    $logfiles = @()
    foreach($path in $Logs){
        $logfiles += Get-ChildItem $path -Recurse -Filter "*.log"
    }

    if($logfiles){
        Write-Output $logfiles.FullName
        exit 1
    }else{
        Write-Output "No files to copy."
        exit 0
    }
} 
catch {
    Write-Error "Error processing detection: $_"
    exit 1
}
