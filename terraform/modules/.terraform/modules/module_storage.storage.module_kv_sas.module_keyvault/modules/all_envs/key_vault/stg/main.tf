
locals {
  ###################
  # Access Policies #
  ###################
  azuread_user_principal_names_custom = var.custom_access_policies_objects[*].azure_ad_user_principal_name
  key_vault_access_policies_custom = [for user, properties in var.custom_access_policies_objects : {
    object_id               = data.azuread_user.custom_user[index(local.azuread_user_principal_names_custom, properties.azure_ad_user_principal_name)].object_id
    key_permissions         = properties.access.key
    secret_permissions      = properties.access.secret
    certificate_permissions = properties.access.certificate
    storage_permissions     = properties.access.storage
    }
  ]
  azuread_user_principal_names = var.access_policies_objects[*].azure_ad_user_principal_name
  key_vault_access_policies = [for user, properties in var.access_policies_objects : {
    object_id               = data.azuread_user.user[index(local.azuread_user_principal_names, properties.azure_ad_user_principal_name)].object_id
    key_permissions         = properties.access.key != null ? var.access_policies_config_by_type["key"]["${properties.access.key}"] : null
    secret_permissions      = properties.access.secret != null ? var.access_policies_config_by_type["secret"]["${properties.access.secret}"] : null
    certificate_permissions = properties.access.certificate != null ? var.access_policies_config_by_type["certificate"]["${properties.access.certificate}"] : null
    storage_permissions     = properties.access.storage != null ? var.access_policies_config_by_type["storage"]["${properties.access.storage}"] : null
    }
  ]
  access_policies = concat(flatten(local.key_vault_access_policies_custom), flatten(local.key_vault_access_policies))

  ###########################################
  # Unused (Reference for possible changes) #
  ###########################################
  # azure_ad_user_principal_names       = var.access_policies[*].azure_ad_user_principal_name
  # object_ids                          = data.azuread_users.users.object_ids
  # access_policies = tolist([for i, policy in var.access_policies : {
  #   object_id               = local.object_ids[i]
  #   key_permissions         = contains(policy.access_type, "key") ? (contains(policy.access_level, "full") ? var.kv_key_permissions_full : var.kv_key_permissions_read) : null
  #   secret_permissions      = contains(policy.access_type, "secret") ? (contains(policy.access_level, "full") ? var.kv_secret_permissions_full : var.kv_secret_permissions_read) : null
  #   certificate_permissions = contains(policy.access_type, "certificate") ? (contains(policy.access_level, "full") ? var.kv_certificate_permissions_full : var.kv_certificate_permissions_read) : null
  #   storage_permissions     = contains(policy.access_type, "storage") ? (contains(policy.access_level, "full") ? var.kv_storage_permissions_full : var.kv_storage_permissions_read) : null
  # }])

  ###########
  # Secrets #
  ###########
  default_secrets = var.default_secrets_enabled ? {
    "Service-Principal-Sparq-Infra-${title(var.env)}-AppId"    = data.external.generate_key_vault_secret[0].result.secret_value_appId,
    "Service-Principal-Sparq-Infra-${title(var.env)}-Password" = data.external.generate_key_vault_secret[0].result.secret_value_password
  } : null
  secrets = merge(var.secrets, local.default_secrets)
}

data "azurerm_client_config" "client_config" {}

data "azuread_user" "custom_user" {
  count               = length(local.azuread_user_principal_names_custom)
  user_principal_name = local.azuread_user_principal_names_custom[count.index]
}
data "azuread_user" "user" {
  count               = length(local.azuread_user_principal_names)
  user_principal_name = local.azuread_user_principal_names[count.index]
}

###########################################
# Unused (Reference for possible changes) #
###########################################

# data "azuread_users" "users" {
#   user_principal_names = local.azure_ad_user_principal_names
# }

# using this basically truncates the name which isn't ideal
# probably best just to keep the limit which is 24 characters in mind
# resource "azurecaf_name" "main" {
#   name          = module.this.id
#   resource_type = "azurerm_key_vault"
#   passthrough   = true
#   clean_input   = true
# }

#############
# Key Vault #
#############
data "azurerm_resource_group" "rg" {
  count = var.enabled_for_deployment ? 1 : 0
  name       = var.key_vault_resource_group_name
  provider   = azurerm.stg
  depends_on = [var.key_vault_stg_depends_on]
}

# Create the Azure Key Vault
resource "azurerm_key_vault" "kv" {
  count = var.enabled_for_deployment ? 1 : 0
  # name                = azurecaf_name.main.result
  name                = var.name
  location            = data.azurerm_resource_group.rg[count.index].location
  resource_group_name = data.azurerm_resource_group.rg[count.index].name
  tenant_id           = data.azurerm_client_config.client_config.tenant_id

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  soft_delete_retention_days = var.soft_delete_retention_days
  enable_rbac_authorization  = var.enable_rbac_authorization
  purge_protection_enabled   = var.purge_protection_enabled

  sku_name = var.key_vault_sku_pricing_tier

  # network_acls {
  #   default_action = "Allow"
  #   bypass         = "AzureServices"
  # }
  # https://github.com/kumarvna/terraform-azurerm-key-vault
  # Default action is set to Allow when no network rules matched. 
  # A virtual_network_subnet_ids or ip_rules can be added to network_acls block to allow request that is not Azure Services.
  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }
  # or 
  # https://github.com/claranet/terraform-azurerm-keyvault/blob/master/r-keyvault.tf
  # dynamic "network_acls" {
  #     for_each = var.network_acls == null ? [] : [var.network_acls]
  #     iterator = acl

  #     content {
  #       bypass                     = coalesce(acl.value.bypass, "None")
  #       default_action             = coalesce(acl.value.default_action, "Deny")
  #       ip_rules                   = acl.value.ip_rules
  #       virtual_network_subnet_ids = acl.value.virtual_network_subnet_ids
  #     }
  #   }

  tags = var.tags
  # additional tags in label or
  # tags = merge({ "ResourceName" = lower("kv-${var.key_vault_name}") }, module.this.tags)

  provider   = azurerm.stg
  depends_on = [var.key_vault_stg_depends_on]

}

###################
# Access Policies #
###################

# Create a Default Azure Key Vault access policy with Admin permissions
# This policy must be kept for a proper run of the "destroy" process
resource "azurerm_key_vault_access_policy" "kv_default_policy" {
  count = var.enabled_for_deployment ? 1 : 0
  key_vault_id = azurerm_key_vault.kv[count.index].id
  tenant_id    = data.azurerm_client_config.client_config.tenant_id
  object_id    = data.azurerm_client_config.client_config.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions         = var.access_policies_config_by_type["key"]["full"]
  secret_permissions      = var.access_policies_config_by_type["secret"]["full"]
  certificate_permissions = var.access_policies_config_by_type["certificate"]["full"]
  storage_permissions     = var.access_policies_config_by_type["storage"]["full"]

  ###########################################
  # Unused (Reference for possible changes) #
  ###########################################
  # key_permissions         = var.kv_key_permissions_full
  # secret_permissions      = var.kv_secret_permissions_full
  # certificate_permissions = var.kv_certificate_permissions_full
  # storage_permissions     = var.kv_storage_permissions_full

  provider = azurerm.stg
}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "kv_add_policy" {
  count        = var.enabled_for_deployment ? length(local.access_policies) : 0
  key_vault_id = azurerm_key_vault.kv[count.index].id

  tenant_id = data.azurerm_client_config.client_config.tenant_id
  object_id = local.access_policies[count.index].object_id

  secret_permissions      = local.access_policies[count.index].secret_permissions
  key_permissions         = local.access_policies[count.index].key_permissions
  certificate_permissions = local.access_policies[count.index].certificate_permissions
  storage_permissions     = local.access_policies[count.index].storage_permissions

  provider = azurerm.stg
}

# for objects
# resource "azurerm_key_vault_access_policy" "access_policies" {
#   for_each                = local.access_policies
#   key_vault_id            = azurerm_key_vault.kv.id
#   tenant_id               = data.azurerm_client_config.client_config.tenant_id
#   object_id               = each.value.object_id
#   key_permissions         = each.value.key_permissions
#   secret_permissions      = each.value.secret_permissions
#   certificate_permissions = each.value.certificate_permissions
#   storage_permissions     = each.value.storage_permissions
# }

###########
# Secrets #
###########

# Generate a random password
resource "random_password" "rdm_pass" {
  for_each    = { for k, v in var.secrets_to_create : k => v if v == "" }
  length      = var.random_password_length
  min_upper   = 4
  min_lower   = 2
  min_numeric = 4
  min_special = 4

  keepers = {
    name = each.key
  }
}

# Add default secrets
data "external" "generate_key_vault_secret" {
  count   = var.default_secrets_enabled ? 1 : 0
  program = ["bash", "${path.module}/../scripts/key_vault_secret.sh"]
  query = {
    key_vault_name       = "kv-sparq-infra-${var.env}"
    secret_name_appId    = "Service-Principal-Sparq-Infra-${title(var.env)}-AppId"
    secret_name_password = "Service-Principal-Sparq-Infra-${title(var.env)}-Password"
  }
}

# Create Azure Key Vault secrets
resource "azurerm_key_vault_secret" "kv_secret" {
  for_each     = merge(var.secrets_to_create, local.secrets)
  key_vault_id = azurerm_key_vault.kv.*.id[0]
  name         = each.key
  value        = each.value != "" ? each.value : random_password.rdm_pass[each.key].result
  # revisit changing tags for secrets based on instantiating another label context
  tags = var.tags
  # additional tags?
  depends_on = [
    var.key_vault_stg_depends_on,
    azurerm_key_vault.kv,
    azurerm_key_vault_access_policy.kv_default_policy
  ]

  provider = azurerm.stg
}
