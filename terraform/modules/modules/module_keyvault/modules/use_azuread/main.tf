# Labels and Tags
module "module_label_key_vault" {
  count = var.enabled_for_deployment ? 1 : 0
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  enabled             = var.enabled_for_deployment
  namespace           = "kv"
  project             = "sparq"
  name                = var.key_vault_application_name
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^a-zA-Z0-9-]/"
  tags = merge(var.tags, {
    "DeploymentSubType" = "key_vault",
    "Environment"       = var.env
  }, var.additional_kv_tags)
}

# Create the Azure Key Vault
locals {
  ###################
  # Access Policies #
  ###################
  ###############
  # Custom User #
  ###############
  # don't recreate default access policy if running as admin_user for proper run of destroy process
  custom_access_policies_objects = [
    for i, properties in var.custom_access_policies_objects : properties if properties.azure_ad_user_principal_name != var.admin_user
  ]

  azuread_user_principal_names_custom = local.custom_access_policies_objects != null ? local.custom_access_policies_objects[*].azure_ad_user_principal_name : null

  key_vault_access_policies_custom = [for user, properties in local.custom_access_policies_objects : {
    object_id               = data.azuread_user.custom_user[index(local.azuread_user_principal_names_custom, properties.azure_ad_user_principal_name)].object_id
    key_permissions         = properties.access.key
    secret_permissions      = properties.access.secret
    certificate_permissions = properties.access.certificate
    storage_permissions     = properties.access.storage
    }
  ]
  ########
  # User #
  ########
  # don't recreate default access policy if running as admin_user for proper run of destroy process
  access_policies_objects = [
    for i, properties in var.access_policies_objects : properties if properties.azure_ad_user_principal_name != var.admin_user
  ]

  azuread_user_principal_names = local.access_policies_objects != null ? local.access_policies_objects[*].azure_ad_user_principal_name : null

  key_vault_access_policies = [for user, properties in local.access_policies_objects : {
    object_id               = data.azuread_user.user[index(local.azuread_user_principal_names, properties.azure_ad_user_principal_name)].object_id
    key_permissions         = properties.access.key != null ? var.access_policies_config_by_type["key"]["${properties.access.key}"] : null
    secret_permissions      = properties.access.secret != null ? var.access_policies_config_by_type["secret"]["${properties.access.secret}"] : null
    certificate_permissions = properties.access.certificate != null ? var.access_policies_config_by_type["certificate"]["${properties.access.certificate}"] : null
    storage_permissions     = properties.access.storage != null ? var.access_policies_config_by_type["storage"]["${properties.access.storage}"] : null
    }
  ]

  ############################
  # Custom Service Principal #
  ############################
  azuread_service_principal_names_custom = var.sp_custom_access_policies_objects != null ? var.sp_custom_access_policies_objects[*].azure_ad_sp_display_name : null

  key_vault_sp_access_policies_custom = [for sp, properties in var.sp_custom_access_policies_objects : {
    object_id               = data.azuread_service_principal.custom_service_principal[index(local.azuread_service_principal_names_custom, properties.azure_ad_sp_display_name)].object_id
    key_permissions         = properties.access.key
    secret_permissions      = properties.access.secret
    certificate_permissions = properties.access.certificate
    storage_permissions     = properties.access.storage
    }
  ]
  #####################
  # Service Principal #
  #####################
  azuread_service_principal_names = var.sp_access_policies_objects != null ? var.sp_access_policies_objects[*].azure_ad_sp_display_name : null

  key_vault_sp_access_policies = [for sp, properties in var.sp_access_policies_objects : {
    object_id               = data.azuread_service_principal.service_principal[index(local.azuread_service_principal_names, properties.azure_ad_sp_display_name)].object_id
    key_permissions         = properties.access.key != null ? var.access_policies_config_by_type["key"]["${properties.access.key}"] : null
    secret_permissions      = properties.access.secret != null ? var.access_policies_config_by_type["secret"]["${properties.access.secret}"] : null
    certificate_permissions = properties.access.certificate != null ? var.access_policies_config_by_type["certificate"]["${properties.access.certificate}"] : null
    storage_permissions     = properties.access.storage != null ? var.access_policies_config_by_type["storage"]["${properties.access.storage}"] : null
    }
  ]

  access_policies = concat(flatten(local.key_vault_access_policies_custom), flatten(local.key_vault_access_policies), flatten(local.key_vault_sp_access_policies_custom), flatten(local.key_vault_sp_access_policies))

  ###########
  # Secrets #
  ###########
  default_secrets = var.default_secrets_enabled ? {
    "Service-Principal-Sparq-Infra-${title(var.env)}-AppId"    = data.external.generate_key_vault_secret[0].result.secret_value_appId,
    "Service-Principal-Sparq-Infra-${title(var.env)}-Password" = data.external.generate_key_vault_secret[0].result.secret_value_password
  } : null
  secrets = merge(var.secrets, local.default_secrets)
}

# (var.is_service_principal == false && data.azuread_user.user.*.user_principal_name[0] != "csoriano@facilisgroup.com")

data "azurerm_client_config" "client_config" {}

data "azuread_user" "admin_user" {
  user_principal_name = var.admin_user
}
data "azuread_user" "custom_user" {
  count               = local.azuread_user_principal_names_custom != null ? length(local.azuread_user_principal_names_custom) : 0
  user_principal_name = local.azuread_user_principal_names_custom[count.index]
  depends_on = [var.key_vault_depends_on]
}
data "azuread_user" "user" {
  count               = local.azuread_user_principal_names != null ? length(local.azuread_user_principal_names) : 0
  user_principal_name = local.azuread_user_principal_names[count.index]
  depends_on = [var.key_vault_depends_on]
}
data "azuread_service_principal" "custom_service_principal" {
  count        = local.azuread_service_principal_names_custom != null ? length(local.azuread_service_principal_names_custom) : 0
  display_name = local.azuread_service_principal_names_custom[count.index]
  depends_on = [var.key_vault_depends_on]
}
data "azuread_service_principal" "service_principal" {
  count        = local.azuread_service_principal_names != null ? length(local.azuread_service_principal_names) : 0
  display_name = local.azuread_service_principal_names[count.index]
  depends_on = [var.key_vault_depends_on]
}

#############
# Key Vault #
#############
data "azurerm_resource_group" "rg" {
  count      = var.enabled_for_deployment ? 1 : 0
  name       = var.key_vault_resource_group_name
  depends_on = [var.key_vault_depends_on]
}

# Create the Azure Key Vault
resource "azurerm_key_vault" "kv" {
  count               = var.enabled_for_deployment ? 1 : 0
  name                = module.module_label_key_vault[count.index].id
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
  tags       = module.module_label_key_vault[count.index].tags
  depends_on = [var.key_vault_depends_on]
}

###################
# Access Policies #
###################

# Create a Default Azure Key Vault access policy with Admin permissions
# This policy must be kept for a proper run of the "destroy" process
resource "azurerm_key_vault_access_policy" "kv_default_policy" {
  count        = var.enabled_for_deployment ? 1 : 0
  key_vault_id = azurerm_key_vault.kv[count.index].id
  tenant_id    = data.azurerm_client_config.client_config.tenant_id
  object_id    = data.azuread_user.admin_user.object_id

  lifecycle {
    create_before_destroy = true
  }

  key_permissions         = var.access_policies_config_by_type["key"]["full"]
  secret_permissions      = var.access_policies_config_by_type["secret"]["full"]
  certificate_permissions = var.access_policies_config_by_type["certificate"]["full"]
  storage_permissions     = var.access_policies_config_by_type["storage"]["full"]

}

# Create an Azure Key Vault access policy
resource "azurerm_key_vault_access_policy" "kv_add_policy" {
  count        = var.enabled_for_deployment ? length(local.access_policies) : 0
  key_vault_id = azurerm_key_vault.kv.*.id[0]

  tenant_id = data.azurerm_client_config.client_config.tenant_id
  object_id = local.access_policies[count.index].object_id

  secret_permissions      = local.access_policies[count.index].secret_permissions
  key_permissions         = local.access_policies[count.index].key_permissions
  certificate_permissions = local.access_policies[count.index].certificate_permissions
  storage_permissions     = local.access_policies[count.index].storage_permissions

}

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
  program = ["bash", "${path.module}/key_vault_secret.sh"]
  query = {
    key_vault_name       = "${var.infra_vault_prefix}-${var.env}"
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
  tags = merge(var.tags, {
    "DeploymentSubType" = "key_vault_secret",
    "Environment"       = var.env
  }, var.additional_kv_secret_tags)
  depends_on = [
    var.key_vault_depends_on,
    azurerm_key_vault.kv,
    azurerm_key_vault_access_policy.kv_default_policy
  ]
}
