try {

    # Declare applications/versions that should not be upgraded
    $ChocoApps_not2Upgrade = @(
        [PSCustomObject]@{
            Name = "snagit"
            Version = "2023.1.1"
        },
        [PSCustomObject]@{
            Name = "veyon"
            Version = "4.8.0"
        }
    )

    # Set a variable to the choco.exe
    $script:choco_exe = "C:\ProgramData\chocolatey\choco.exe"
    # Get the list of locally installed Chocolatey packages
    $ChocoApps_local = &$choco_exe list --local-only -r

    # Get pinned apps
    $ChocoApps_rawpinned = &$choco_exe pin list -r
    $ChocoApps_pinned= @()
    # Convert the variable into an array (if existing)
    if($ChocoApps_rawpinned){
        [System.Array]$ChocoApps_pinned = $ChocoApps_rawpinned -split "`n" | ForEach-Object {
            $name, $version = $_ -split '\|'
            [PSCustomObject]@{
                Name = $name.Trim()
                Version = $version.Trim()
            }
        }
    }


    $ChocolocalApps_not2Upgrade = @()
    ForEach($ChocoApp in $ChocoApps_not2Upgrade){
        if($ChocoApps_local -like "*$($ChocoApp.Name)*"){
            $ChocolocalApps_not2Upgrade += $ChocoApp
        }
    }

    if($ChocolocalApps_not2Upgrade){
    
        $equal = $true
        foreach ($chocoApp in $ChocolocalApps_not2Upgrade) {
            $match = $ChocoApps_pinned | Where-Object { $_.Name -eq $chocoApp.Name }
            
            if ($match) {
                if ($chocoApp.Version -ne "" -and $match.Version -ne $chocoApp.Version) {
                    $equal = $false
                    break
                }
            } else {
                $equal = $false
                break
            }
        }

        if ($equal -and $ChocolocalApps_not2Upgrade.Count -eq $ChocoApps_pinned.Count) {
            #Write-Host "Arrays are equal."
        } else {
            Write-Host "Pinned apps are not equal, currently pinned: $($ChocoApps_pinned.Name)"
            exit 1
        }
    }

    # Get the list of outdated Chocolatey packages
    $ChocoApps_upgrade = &$choco_exe outdated -r

    if($ChocoApps_upgrade -like "*|false*"){
        Write-Host "There are apps in need of updates"
        exit 1
    }
    else {
        Write-Output "No upgrades available."
        exit 0
    }

}catch {
    Write-Error $_
    Exit 1
}




















