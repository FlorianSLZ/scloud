$Profile_age = 35 # max profile age in days

Try {

    # Get all User profile folders older than X days
    $LastAccessedFolder = Get-ChildItem "C:\Users" |  Where-Object {$_ -notlike "*Windows*" -and $_ -notlike "*default*" -and $_ -notlike "*Public*" -and $_ -notlike "*Admin*"} | Where LastWriteTime -lt (Get-Date).AddDays(-$Profile_age)

    # Filter the list of folders to only include those that are not associated with local user accounts
    $Profiles_notLocal = $LastAccessedFolder | Where-Object { $_.Name -notin $(Get-LocalUser).Name }

    # Retrieve a list of user profiles and filter to only include the old ones
    $Profiles_2remove = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath -in $($Profiles_notLocal.FullName) }

    if($Profiles_2remove){
        # Removing all old profiles
        $Profiles_2remove | Remove-CimInstance
    }else{
        Write-Output "No profiles oldter than $Profile_age days found. "
    }

} 
Catch {
    Write-Error $_
}
