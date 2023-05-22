# Install Microft Graph Module
Install-Module Microsoft.Graph -Scope CurrentUser

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"

# Select beta profile
Select-MgProfile Beta

# You will be prompted for the Name of you Managed Identity
$MdId_Name = Read-Host "Name of your Managed Identity"
$MdId_ID = (Get-MgServicePrincipal -Filter "displayName eq '$MdId_Name'").id

# Adding Microsoft Graph permissions
$graphApp = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

# Add the required Graph scopes
$graphScopes = @(
  "DeviceManagementManagedDevices.Read.All"
)
ForEach($scope in $graphScopes){
  $appRole = $graphApp.AppRoles | Where-Object {$_.Value -eq $scope}

  if ($null -eq $appRole) { Write-Warning "Unable to find App Role for scope $scope"; continue; }

  # Check if permissions isn't already assigned
  $assignedAppRole = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $MdId_ID | Where-Object { $_.AppRoleId -eq $appRole.Id -and $_.ResourceDisplayName -eq "Microsoft Graph" }

  if ($null -eq $assignedAppRole) {
    New-MgServicePrincipalAppRoleAssignment -PrincipalId $MdId_ID -ServicePrincipalId $MdId_ID -ResourceId $graphApp.Id -AppRoleId $appRole.Id
  }else{
    write-host "Scope $scope already assigned"
  }
}

