try{

    # Declare applications/versions that should not be upgraded
    $ChocoApps_not2Upgrade = @(
        [PSCustomObject]@{
            Name = "examplechocoid1"
            Version = "2023.1.1"
        },
        [PSCustomObject]@{
            Name = "examplechocoid2"
            Version = ""
        }
    )

    $output = @()

    # Set a variable to the choco.exe
    $script:choco_exe = "C:\ProgramData\chocolatey\choco.exe"
    # Get the list of locally installed Chocolatey packages
    $ChocoApps_local = &$choco_exe list -r
    # Get the list of outdated Chocolatey packages
    $ChocoApps_upgrade = &$choco_exe outdated -r


    # Loop through each application that should not be upgraded
    # If the application is installed locally, pin it to its current version
    # If the application is not on the pionned version, install it at the specified version and pin it
    ForEach($ChocoApp in $ChocoApps_not2Upgrade){
        if($ChocoApps_local -like "*$($ChocoApp.Name)*"){
            $AddApp =  &$choco_exe pin add --name="$($ChocoApp.Name)" --version="$($ChocoApp.Version)" -r
            if($AddApp -like "*Unable to find package named*"){
                $null = &$choco_exe install $($ChocoApp.Name) -y --version=$($ChocoApp.Version) --force
                &$choco_exe pin add --name="$($ChocoApp.Name)" --version="$($ChocoApp.Version)" -r
            }else{
                $output += $AddApp
            }
        }
    }

    # Get pinned apps
    $ChocoApps_rawpinned = &$choco_exe pin list -r
    $ChocoApps_pinned= @()
    # Convert the variable into an array
    [System.Array]$ChocoApps_pinned = $ChocoApps_rawpinned -split "`n" | ForEach-Object {
        $name, $version = $_ -split '\|'
        [PSCustomObject]@{
            Name = $name.Trim()
            Version = $version.Trim()
        }
    }
    foreach ($chocoapp_pin in $ChocoApps_pinned){
        if($chocoapp_pin.Name -notin $ChocoApps_not2Upgrade.Name){
            &$choco_exe pin remove --name="$($chocoapp_pin.Name)"
        }
    }
    
    # Loop through each outdated application
    # Add it to a list of applications to be upgraded if it should not be excluded from upgrading
    $ChocoApps_2upgrade = @()
    foreach($id in $ChocoApps_upgrade){
        $pos = $id.IndexOf("|")
        $idonly = $id.Substring(0, $pos)
        if($idonly -notin $($ChocoApps_not2Upgrade.Name)){
            $ChocoApps_2upgrade += $idonly
        }
    }

    # If there are applications to be upgraded, upgrade them
    if ($ChocoApps_2upgrade) {
        &$choco_exe upgrade $ChocoApps_2upgrade -y
    }
    else {
        Write-Output "No upgrades available. `n process output: $output"
    }



}catch{
    Write-Error $_
}