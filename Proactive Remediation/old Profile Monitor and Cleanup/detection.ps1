$Profile_age = 35 # max profile age in days

Try {

    # Get all User profiles older than x days
    $LastAccessedFolder = Get-ChildItem "C:\Users" |  Where-Object {$_ -notlike "*Windows*" -and $_ -notlike "*default*" -and $_ -notlike "*Public*" -and $_ -notlike "*Admin*"} | Where LastWriteTime -lt (Get-Date).AddDays(-$Profile_age)

    $Profiles_notLocal = $LastAccessedFolder | Where-Object { $_.Name -notin $(Get-LocalUser).Name }
    $Profiles_2remove = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.LocalPath -in $($Profiles_notLocal.FullName) }

    if($Profiles_2remove){
        Write-Warning "Old profiles ($Profile_age days+): $($Profiles_2remove.LocalPath)"
        Exit 1
    }else{
        Write-Output -NoEnumerate $(Get-CimInstance -Class Win32_UserProfile | Select-Object LocalPath, LastUseTime)
        Exit 0
    }

} 
Catch {
    Write-Error $_
}
