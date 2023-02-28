$CompanyName = "scloud"
$Folder = "Desktop"

try {

    # OneDrive Path
    $OneDrive_path = "$($home)\OneDrive - $CompanyName\$Folder"

    $MainStatus_current = $(attrib.exe $OneDrive_path) -replace(" ","")
    $MainStatus_target = "RP"+$($OneDrive_path) -replace(" ","")
    if($MainStatus_current -ne $MainStatus_target){
        Write-Warning "Not offline aviable: $OneDrive_path"
        exit 1
    }else{
        # Child Items
        $ChildItems = Get-ChildItem -Path $OneDrive_path -Recurse

        Foreach($child in $ChildItems){
            $ChildStatus_current = $(attrib.exe $child.FullName) -replace(" ","")
            $ChildStatus_target = "AP"+$($child.FullName) -replace(" ","")
            if($ChildStatus_current -ne $ChildStatus_target){
                Write-Warning "Not all files are offline aviable."
                exit 1
            }
        }
        
        Write-Output "Files and Folders already offline aviable"
        exit 0

    }
} 
catch {
    Write-Error "Error Processing detection: $_"
    exit 1
}
