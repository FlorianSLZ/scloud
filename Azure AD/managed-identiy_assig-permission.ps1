# Install-Module Microsoft.Graph

# Add the correct 'Object (principal) ID' for the Managed Identity
$ObjectId = "0fba54b6-91e9-42b6-9de6-80b089a52d98"

# Add the correct Graph scope to grant
$graphScope = "Sites.Manage.All" # "Sites.Selected", "Sites.Manage.All"

Connect-MgGraph -Scope "AppRoleAssignment.ReadWrite.All", "Application.Read.All"
$graph = Get-MgServicePrincipal -Filter "AppId eq '00000003-0000-0000-c000-000000000000'"
$graphAppRole = $graph.AppRoles | Where-Object Value -eq $graphScope

$appRoleAssignment = @{
    "principalId" = $ObjectId
    "resourceId"  = $graph.Id
    "appRoleId"   = $graphAppRole.Id
}

New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $ObjectID -BodyParameter $appRoleAssignment | Format-List
