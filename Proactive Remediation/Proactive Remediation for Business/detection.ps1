try{
    $DesctopItems_copy = Get-ChildItem "C:\Users\*\Desktop\*- Copy*.lnk"
    $DesctopItems_copy += Get-ChildItem "C:\Users\*\OneDrive - *\Desktop\*- Copy*.lnk"

    If($DesctopItems_copy){exit 1}else{exit 0} # exit 1 = detectet, remediation needed
}catch{
    Write-Error $_
}
