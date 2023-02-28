$CompanyName = "scloud"
$Folder = "Desktop"

try{

    # OneDrive Path
    $OneDrive_path = "$($home)\OneDrive - $CompanyName\$Folder"

    # Process main folder 
    attrib.exe $OneDrive_path -U +P /s /d

    # Process child items 
    Get-ChildItem $OneDrive_path -Recurse | Select-Object Fullname | ForEach-Object { attrib.exe $_.FullName -U +P }

}catch{
    Write-Error $_
}
