try{
    if (Get-AppxPackage -Name "Microsoft.OutlookForWindows")
    {
        Write-Host "Detected: New Microsoft Outlook found."
        exit 1
    }
    else
    {
        Write-Host "New Microsoft Outlook not found."    
        exit 0

    }
}
catch{
    Write-Error "Error detecting the New Microsoft Outlook."
    exit 1
}