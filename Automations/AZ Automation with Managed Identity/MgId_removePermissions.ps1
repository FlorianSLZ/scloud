# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"

# Select beta profile
Select-MgProfile Beta

# You will be prompted for the Name of you Managed Identity
$MdId_Name = Read-Host "Name of your Managed Identity"
$MdId_ID = (Get-MgServicePrincipal -Filter "displayName eq '$MdId_Name'").id

# Removing all Graph scopes
$MdId_permissions = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $MdId_ID
ForEach($Assignment in $MdId_permissions){
  Remove-MgServicePrincipalAppRoleAssignment -AppRoleAssignmentId $Assignment.Id -ServicePrincipalId $MdId_ID
}
