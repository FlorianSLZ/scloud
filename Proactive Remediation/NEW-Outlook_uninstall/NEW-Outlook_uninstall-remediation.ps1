try{
    Get-AppxPackage -Name "Microsoft.OutlookForWindows" | Remove-AppxPackage -ErrorAction Stop
    Write-Host "New Microsoft Outlook successfully removed."

}
catch{
    Write-Error "Error removing the New Microsoft Outlook: " + $_.Exception.Message
}
