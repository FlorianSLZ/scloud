# Install Microft Graph Module
Install-Module Microsoft.Graph -Scope CurrentUser


# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"

# Select beta profile
Select-MgProfile Beta


# Change this to your Managed Identity app name:
$managedIdentityName = "scloud"
$managedIdentityId = (Get-MgServicePrincipal -Filter "displayName eq $managedIdentityName").id


# Adding Microsoft Graph permissions
$graphApp = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

# Add the required Graph scopes
$graphScopes = @(
  'UserAuthenticationMethod.Read.All',
  'Group.ReadWrite.All',
  'Directory.Read.All',
  'User.ReadWrite.All'
)
ForEach($scope in $graphScopes){
  $appRole = $graphApp.AppRoles | Where-Object {$_.Value -eq $scope}

  if ($null -eq $appRole) { Write-Warning "Unable to find App Role for scope $scope"; continue; }

  # Check if permissions isn't already assigned
  $assignedAppRole = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $managedIdentityId | Where-Object { $_.AppRoleId -eq $appRole.Id -and $_.ResourceDisplayName -eq "Microsoft Graph" }

  if ($null -eq $assignedAppRole) {
    New-MgServicePrincipalAppRoleAssignment -PrincipalId $managedIdentityId -ServicePrincipalId $managedIdentityId -ResourceId $graphApp.Id -AppRoleId $appRole.Id
  }else{
    write-host "Scope $scope already assigned"
  }
}

