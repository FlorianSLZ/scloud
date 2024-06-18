Start-Transcript -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\WIN-S-D-LAPS-Admin.log" -Force

$UserName = "lolaps"
$GroupSID = "S-1-5-32-544" # admin group

Add-Type -AssemblyName 'System.Web'

$Description = 'LAPS Client Admin'
$Password = [System.Web.Security.Membership]::GeneratePassword(24, 0) | ConvertTo-SecureString -AsPlainText -Force

#  creating user
if(Get-LocalUser $UserName -ErrorAction SilentlyContinue){
    Write-Host "User already exists."
}else{
    Write-Host "Creating user: $UserName"
    New-LocalUser -Name $UserName -Description $Description -Password $Password -ErrorAction Stop
}


# adding user to admin group

# Get all GroupMember of local Admins
foreach ($group in Get-LocalGroup -SID $GroupSID )
{
	$group = [ADSI]"WinNT://$env:COMPUTERNAME/$group"
	$LocalAdmins = @($group.Invoke('Members') | ForEach-Object {([adsi]$_).path})
}

$userFound = $LocalAdmins -match "/$UserName$"
if ($userFound) {
    Write-Host "User is already an admin."
} else {
    Write-Host "Adding user to Admingroup ($GroupSID): $UserName"
    Add-LocalGroupMember -SID $GroupSID -Member $UserName -ErrorAction Stop
}

Stop-Transcript
