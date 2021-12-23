locals {
  key_vault_terraform_variables = [
    for variable in var.terraform_variables : variable if variable.type == "KEY_VAULT"
  ]
  key_vault_environment_variables = [
    for variable in var.environment_variables : variable if variable.type == "KEY_VAULT"
  ]
  key_vault_terraform_keys = [
    for variable in var.terraform_variables : variable.key if variable.type == "KEY_VAULT"
  ]
  key_vault_environment_keys = [
    for variable in var.environment_variables : variable.key if variable.type == "KEY_VAULT"
  ]
}

locals {
  key_vault_terraform_variable_map   = zipmap(local.key_vault_terraform_keys, local.key_vault_terraform_variables)
  key_vault_environment_variable_map = zipmap(local.key_vault_environment_keys, local.key_vault_environment_variables)
}

data "tfe_workspace" "this_workspace" {
  count        = var.workspace == null ? 0 : 1
  name         = var.workspace
  organization = var.tfc_organization
}
data "azurerm_key_vault" "dev" {
  count               = length(concat(local.key_vault_terraform_keys, local.key_vault_environment_keys)) > 0 && var.env == "dev" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
  provider            = azurerm.dev
  depends_on = [
    var.workspace_variables_dev_depends_on
  ]
}
data "azurerm_key_vault" "stg" {
  count               = length(concat(local.key_vault_terraform_keys, local.key_vault_environment_keys)) > 0 && var.env == "stg" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
  provider            = azurerm.stg
  depends_on = [
    var.workspace_variables_stg_depends_on
  ]
}
data "azurerm_key_vault" "prd" {
  count               = length(concat(local.key_vault_terraform_keys, local.key_vault_environment_keys)) > 0 && var.env == "prd" ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
  provider            = azurerm.prd
  depends_on = [
    var.workspace_variables_prd_depends_on
  ]
}

data "azurerm_key_vault_secret" "terraform_variable_parameters" {
  for_each = local.key_vault_terraform_variable_map
  name     = each.value.value
  # key_vault_id = var.env == "stg" ? data.azurerm_key_vault.stg.id : (var.env == "dev" ? data.azurerm_key_vault.dev.id : data.azurerm_key_vault.prd.id)
  key_vault_id = var.env == "stg" ? data.azurerm_key_vault.stg[0].id : (var.env == "dev" ? data.azurerm_key_vault.dev[0].id : data.azurerm_key_vault.prd[0].id)

}

data "azurerm_key_vault_secret" "terraform_environment_parameters" {
  for_each     = local.key_vault_environment_variable_map
  name         = each.value.value
  key_vault_id = var.env == "stg" ? data.azurerm_key_vault.stg[0].id : (var.env == "dev" ? data.azurerm_key_vault.dev[0].id : data.azurerm_key_vault.prd[0].id)
}

locals {
  workspace_id = var.workspace_id == null ? try(data.tfe_workspace.this_workspace[0].id, null) : var.workspace_id
  full_terraform_variables = [
    for variable in var.terraform_variables :
    variable.type == "PLAIN_TEXT" ?
    {
      key         = variable.key
      description = variable.description
      type        = variable.type
      value       = variable.value
      sensitive   = variable.sensitive
    } :
    {
      key         = variable.key
      description = variable.description
      type        = variable.type
      value       = data.azurerm_key_vault_secret.terraform_variable_parameters[variable.key].value
      sensitive   = variable.sensitive
    }
  ]
  full_environment_variables = [
    for variable in var.environment_variables :
    variable.type == "PLAIN_TEXT" ?
    {
      key         = variable.key
      description = variable.description
      type        = variable.type
      value       = variable.value
      sensitive   = variable.sensitive
    } :
    # this didn't work to substitute the vars because this is the lookup local 😅
    # substr(variable.key, 0, 17) == "Service-Principal" && substr(variable.key, -5, 0) == "AppId" ?
    # {
    #   key         = "ARM_CLIENT_ID"
    #   description = variable.description
    #   type        = variable.type
    #   value       = data.azurerm_key_vault_secret.terraform_environment_parameters[variable.key].value
    #   sensitive   = variable.sensitive
    # } :
    # substr(variable.key, 0, 17) == "Service-Principal" && substr(variable.key, -8, 0) == "Password" ?
    # {
    #   key         = "ARM_CLIENT_SECRET"
    #   description = variable.description
    #   type        = variable.type
    #   value       = data.azurerm_key_vault_secret.terraform_environment_parameters[variable.key].value
    #   sensitive   = variable.sensitive
    # } :
    {
      key         = variable.key
      description = variable.description
      type        = variable.type
      value       = data.azurerm_key_vault_secret.terraform_environment_parameters[variable.key].value
      sensitive   = variable.sensitive
    }
  ]
}

resource "tfe_variable" "terraform_variables" {
  count        = length(local.full_terraform_variables)
  key          = local.full_terraform_variables[count.index].key
  value        = local.full_terraform_variables[count.index].value
  category     = "terraform"
  workspace_id = local.workspace_id
  description  = local.full_terraform_variables[count.index].description
  sensitive    = local.full_terraform_variables[count.index].sensitive
}

resource "tfe_variable" "environment_variables" {
  count        = length(local.full_environment_variables)
  key          = local.full_environment_variables[count.index].key
  value        = local.full_environment_variables[count.index].value
  category     = "env"
  workspace_id = local.workspace_id
  description  = local.full_environment_variables[count.index].description
  sensitive    = local.full_environment_variables[count.index].sensitive
}

# resource "tfe_variable" "environment_variables" {
#   count        = length(local.full_environment_variables)
#   key          = (
#     substr(local.full_environment_variables[count.index].key, 0, 17) == "Service-Principal" && substr(local.full_environment_variables[count.index].key, -5, 0) == "AppId"
#       ? "ARM_CLIENT_ID"
#       : substr(local.full_environment_variables[count.index].key, 0, 17) == "Service-Principal" && substr(local.full_environment_variables[count.index].key, -8, 0) == "Password"
#           ? "ARM_CLIENT_SECRET"
#           : local.full_environment_variables[count.index].key
#   )
#   value        = local.full_environment_variables[count.index].value
#   category     = "env"
#   workspace_id = local.workspace_id
#   description  = local.full_environment_variables[count.index].description
#   sensitive    = local.full_environment_variables[count.index].sensitive
# }