[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [String]$Environment,
    [Parameter(Mandatory = $true)]
    [String]$RoleName,
    [Parameter(Mandatory = $true)]
    [bool]$HasRoleAssignment
)
az account set -s "sparq-$Environment"
$roleAssignment=$(az role definition list --name $RoleName --query '[0].roleName' -o tsv)
$roleAssignmentIsEmpty=[string]::IsNullOrEmpty($roleAssignment)

# if ($HasRoleAssignment -eq $true) {
#   $desiredState = $($roleAssignmentIsEmpty -eq $false)
# }

$desiredState=($HasRoleAssignment -eq $true ? ($roleAssignmentIsEmpty -eq $false) : ($roleAssignmentIsEmpty -eq $true))
while ($desiredState -eq $false) {
  # Start-Sleep -Seconds 10
  $roleAssignment=$(az role definition list --name $RoleName --query '[0].roleName' -o tsv)
  $roleAssignmentIsEmpty=[string]::IsNullOrEmpty($roleAssignment)
  $desiredState=($HasRoleAssignment -eq $true ? ($roleAssignmentIsEmpty -eq $false) : ($roleAssignmentIsEmpty -eq $true))
  Write-Host "Trying to fetch role assignment $RoleName" -ForegroundColor Green
  Write-Host "Ensuring $RoleName empty state is $desiredState" -ForegroundColor Magenta
  Write-Host "Fetched role assignment is `"-> $roleAssignment <-`"" -ForegroundColor Magenta
  Write-Host "$RoleName empty state is $roleAssignmentIsEmpty" -ForegroundColor Magenta
}
if ($desiredState -eq $true) {
  Write-Host "Desired State is $desiredState" -ForegroundColor Green
  Write-Host "Role assignment" -ForegroundColor Green
  Write-Host "`t$RoleName is $HasRoleAssignment" -ForegroundColor Magenta
  exit 0
}

# module.module_service_principal.null_resource.verify_role_creation[0] (local-exec): Trying to fetch role assignment AssignPermissionsRoleStg
# module.module_service_principal.null_resource.verify_role_creation[0] (local-exec): Ensuring AssignPermissionsRoleStg is False
# module.module_service_principal.null_resource.verify_role_creation[0] (local-exec): AssignPermissionsRoleStg empty state is True