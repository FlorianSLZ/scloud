$PackageName = "WIN-S-D-NetworkConfigurationOperators"
$Version = 1

Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\$PackageName-script.log" -Force -Append

$ScheduledTask = Get-ScheduledTask -TaskName $PackageName -ErrorAction SilentlyContinue
if($ScheduledTask.Description -eq $Version){
    
    $loggedonuser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName
    $groupSID = "S-1-5-32-556"  # Network Configuration Operators

    Write-Output "Logged-on user: $loggedonuser"
    Write-Output "Checking group membership..."

    $members = Get-LocalGroupMember -SID $groupSID -ErrorAction Stop
    if ($members.Name -contains $loggedonuser) {
        Write-Output "$loggedonuser is already a member of the group."
    } else {
        Write-Output "Adding $loggedonuser to the group..."
        Add-LocalGroupMember -SID $groupSID -Member $loggedonuser
        Write-Output "$loggedonuser successfully added to the group."
    }


}else{

    # create custom folder and write PS script 
    $Path_folder = "$env:ProgramData\Intune-Script"
    $Path_script = "$Path_folder\$PackageName.ps1"

    if (!(Test-Path $Path_folder)){ New-Item -Path $Path_folder -ItemType Directory -Force -Confirm:$false  } 

    Out-File -InputObject $(Get-Content -Path $($PSCommandPath)) -FilePath $Path_script -Force -Confirm:$false 

    # register script as scheduled task 
    $Trigger    =   New-ScheduledTaskTrigger -AtLogOn 
    $User       =   "SYSTEM" 
    $Action     =   New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$Path_script`"" 

    Register-ScheduledTask -TaskName $PackageName -Description $Version -Trigger $Trigger -User $User -Action $Action -Force 

}

Stop-Transcript
