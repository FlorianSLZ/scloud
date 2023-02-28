$CompanyName = "scloud"

try{

    # OneDrive Path
    $OneDrive_path = "$($home)\OneDrive - $CompanyName\Desktop"

    # Process main folder 
    attrib.exe $OneDrive_path -U +P /s /d

    # Process child items 
    Get-ChildItem $OneDrive_path -Recurse | Select-Object Fullname | ForEach-Object { attrib.exe $_.FullName -U +P }

}catch{
    Write-Error $_
}
