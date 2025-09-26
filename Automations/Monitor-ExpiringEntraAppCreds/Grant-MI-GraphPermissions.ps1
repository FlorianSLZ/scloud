<#
.SYNOPSIS
  Assign Microsoft Graph application permissions to a Managed Identity.

.DESCRIPTION
  - This script assigns Graph **App Role permissions** (Application permissions) 
    directly to a Managed Identity service principal in Entra ID.
  - Useful for Azure Automation accounts or other Managed Identities that need 
    to run scripts against Microsoft Graph without user interaction.
  - In this example, the Managed Identity is granted:
        * Application.Read.All
        * Mail.Send

.REQUIREMENTS
  - Microsoft.Graph.Authentication and Microsoft.Graph.Applications modules installed.
  - You must be a Directory Admin (or have equivalent rights to assign app roles).


.EXAMPLE
  .\Grant-MI-GraphPermissions.ps1

  Prompts you for the Managed Identity name and assigns 
  Application.Read.All and Mail.Send permissions.

.NOTES
  Author: Florian Salzmann (@FlorianSLZ)
  Blog:   https://scloud.work
  Version: 1.0
  Date:    2025-09-26
#>

# Connect to Microsoft Graph with delegated permissions (interactive login)
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All","RoleManagement.ReadWrite.Directory"

# Prompt for the name of your Managed Identity
$MdId_Name = Read-Host "Name of your Managed Identity"
$MdId_ID = (Get-MgServicePrincipal -Filter "displayName eq '$MdId_Name'").id

# Get the Microsoft Graph Service Principal
$graphApp = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

# Define required Graph application roles (scopes)
$graphScopes = @(
  "Application.Read.All",
  "Mail.Send"
)

foreach ($scope in $graphScopes) {
  $appRole = $graphApp.AppRoles | Where-Object { $_.Value -eq $scope }

  if (-not $appRole) { 
    Write-Warning "Unable to find App Role for scope $scope" 
    continue 
  }

  # Check if the permission is already assigned
  $assignedAppRole = Get-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $MdId_ID | Where-Object { 
    $_.AppRoleId -eq $appRole.Id -and $_.ResourceDisplayName -eq "Microsoft Graph" 
  }

  if (-not $assignedAppRole) {
    New-MgServicePrincipalAppRoleAssignment `
      -PrincipalId $MdId_ID `
      -ServicePrincipalId $MdId_ID `
      -ResourceId $graphApp.Id `
      -AppRoleId $appRole.Id
    Write-Host "Assigned $scope to $MdId_Name"
  }
  else {
    Write-Host "Scope $scope already assigned to $MdId_Name"
  }
}


# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.Read.All","AppRoleAssignment.ReadWrite.All,RoleManagement.ReadWrite.Directory"

# You will be prompted for the Name of you Managed Identity
$MdId_Name = Read-Host "Name of your Managed Identity"
$MdId_ID = (Get-MgServicePrincipal -Filter "displayName eq '$MdId_Name'").id

# Adding Microsoft Graph permissions
$graphApp = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"

# Add the required Graph scopes
$graphScopes = @(
  "Application.Read.All",
  "Mail.Send"
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

