module "module_service_principal" {
  source        = "../modules"
  debug_outputs = false
  # this must be set to true to output client_secret and service_principal_password
  debug_sensitive_outputs    = true
  enabled_for_deployment     = var.enabled_for_deployment
  application_name           = var.application_name
  service_principal_location = var.service_principal_location
  env                        = var.env
  sign_in_audience           = "AzureADMyOrg"
  description                = "This is a service principal to test the service principal module in the ${var.env} environment."
  password_rotation_in_years = var.password_rotation_in_years
  # Adding roles and scope to service principal
  custom_roles = [
    {
      name        = "AssignPermissionsTestRole${title(var.env)}"
      description = "This is a role that allows assignment of permissions. To be used by service principal for assigning SAS permissions in storage account creation in the ${var.env} environment."
      permissions = {
        actions = ["Microsoft.Authorization/roleAssignments/write"]
      }
      assignable_scopes = [
        "/subscriptions/${var.azure_subscription_id}"
      ]
    }
  ]
  # custom_roles_json = [
  #   {
  #     Name        = "AssignPermissionsTestRole${title(var.env)}"
  #     Description = "This is a role that allows assignment of permissions. To be used by service principal for assigning SAS permissions in storage account creation in the ${var.env} environment."
  #     Actions     = ["Microsoft.Authorization/roleAssignments/write"]
  #     AssignableScopes = [
  #       "/subscriptions/${var.azure_subscription_id}"
  #     ]
  #   }
  # ]
  assignments = [
    {
      scope                = "/subscriptions/${var.azure_subscription_id}"
      role_definition_name = "Contributor"
    }
  ]
  custom_assignments = [
    {
      scope                = "/subscriptions/${var.azure_subscription_id}"
      role_definition_name = "AssignPermissionsTestRole${title(var.env)}"
      description          = "This is a role assignment that allows assignment of permissions. To be used by service principal for assigning SAS permissions in storage account creation in the ${var.env} environment."
    }
  ]
  # azuread_service_principal_password
  enable_service_principal_certificate = false
  sp_tags                              = var.sp_tags
}

