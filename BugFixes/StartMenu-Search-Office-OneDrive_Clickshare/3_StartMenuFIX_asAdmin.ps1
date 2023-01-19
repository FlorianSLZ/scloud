$objSID = New-Object System.Security.Principal.SecurityIdentifier ("S-1-15-2-1")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$user = $objUser.Value
$Packages = $user.Split("\") 
$Packages = $Packages[1]


$key = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\S-1-12-1-*'
$profiles = (Get-Item $key)

New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS

Foreach ($profile in $profiles) {
$sids = $profile
$sids = Split-path -path $sids -leaf
$user = "HKU:\$sids\"
$test = test-path $user

if ($test -eq $true){ 
$Folder = "HKU:\$sids\Software\Microsoft\windows\currentversion\explorer\"
$Acl = Get-ACL $folder
$AccessRule= New-Object System.Security.AccessControl.RegistryAccessRule($Packages,"Readkey","ContainerInherit","None","Allow")
$Acl.SetAccessRule($AccessRule)
Set-Acl $folder $Acl

$Folder = "HKU:\$sids\Software\Microsoft\windows\currentversion\explorer\user shell folders"
$Acl = Get-ACL $folder
$AccessRule= New-Object System.Security.AccessControl.RegistryAccessRule($Packages,"Readkey","ContainerInherit","None","Allow")
$Acl.SetAccessRule($AccessRule)
Set-Acl $folder $Acl
}     
}

Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}