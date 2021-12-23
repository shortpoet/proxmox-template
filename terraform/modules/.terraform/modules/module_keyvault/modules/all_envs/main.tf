locals {
  # workspaces = { for env, values in var.keyvault_environments : "${var.workspace_prefix}-${env}" => env }
  default = {
    enabled                         = true
    debug_outputs                   = true
    debug_sensitive_outputs         = true
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = true
    soft_delete_retention_days      = 90
    enable_rbac_authorization       = false
    purge_protection_enabled        = false
    key_vault_sku_pricing_tier      = "standard"
    network_acls                    = null
    access_policies_objects = [
      {
        azure_ad_user_principal_name = "lgraves@facilisgroup.com"
        access = {
          key         = null
          secret      = "read"
          certificate = null
          storage     = null
        }
      },
      {
        azure_ad_user_principal_name = "egabbard@facilisgroup.com"
        access = {
          key         = null
          secret      = "full"
          certificate = null
          storage     = null
        }
      }
    ]
    custom_access_policies_objects = []
    random_password_length         = 24
    secrets                        = {}
    default_secrets_enabled        = true
  }
  keyvault_environments = { for env, values in var.keyvault_environments : env => {
    enabled                         = values.enabled == null ? local.default.enabled : values.enabled
    debug_outputs                   = values.debug_outputs == null ? local.default.debug_outputs : values.debug_outputs
    debug_sensitive_outputs         = values.debug_sensitive_outputs == null ? local.default.debug_sensitive_outputs : values.debug_sensitive_outputs
    key_vault_resource_group_name   = values.key_vault_resource_group_name
    key_vault_name                  = values.key_vault_name
    enabled_for_disk_encryption     = values.enabled_for_disk_encryption == null ? local.default.enabled_for_disk_encryption : values.enabled_for_disk_encryption
    enabled_for_template_deployment = values.enabled_for_template_deployment == null ? local.default.enabled_for_template_deployment : values.enabled_for_template_deployment
    soft_delete_retention_days      = values.soft_delete_retention_days == null ? local.default.soft_delete_retention_days : values.soft_delete_retention_days
    enable_rbac_authorization       = values.enable_rbac_authorization == null ? local.default.enable_rbac_authorization : values.enable_rbac_authorization
    purge_protection_enabled        = values.purge_protection_enabled == null ? local.default.purge_protection_enabled : values.purge_protection_enabled
    key_vault_sku_pricing_tier      = values.key_vault_sku_pricing_tier == null ? local.default.key_vault_sku_pricing_tier : values.key_vault_sku_pricing_tier
    tags                            = values.tags
    network_acls                    = values.network_acls == null ? local.default.network_acls : values.network_acls
    access_policies_objects         = values.access_policies_objects == null ? local.default.access_policies_objects : values.access_policies_objects
    custom_access_policies_objects  = values.custom_access_policies_objects == null ? local.default.custom_access_policies_objects : values.custom_access_policies_objects
    secrets                         = values.secrets == null ? local.default.secrets : values.secrets
    secrets_to_create               = values.secrets_to_create
    default_secrets_enabled         = values.default_secrets_enabled == null ? local.default.default_secrets_enabled : values.default_secrets_enabled
    depends_on                      = values.depends_on
    }
  }
}
module "key_vault_dev" {
  source                        = "./key_vault/dev"
  env                           = "dev"
  key_vault_resource_group_name = local.keyvault_environments["dev"].key_vault_resource_group_name
  name                          = local.keyvault_environments["dev"].key_vault_name
  enabled_for_deployment        = local.keyvault_environments["dev"].enabled

  key_vault_sku_pricing_tier      = local.keyvault_environments["dev"].key_vault_sku_pricing_tier
  enabled_for_disk_encryption     = local.keyvault_environments["dev"].enabled_for_disk_encryption
  enabled_for_template_deployment = local.keyvault_environments["dev"].enabled_for_template_deployment
  soft_delete_retention_days      = local.keyvault_environments["dev"].soft_delete_retention_days
  enable_rbac_authorization       = local.keyvault_environments["dev"].enable_rbac_authorization
  purge_protection_enabled        = local.keyvault_environments["dev"].purge_protection_enabled

  network_acls                   = local.keyvault_environments["dev"].network_acls
  access_policies_objects        = local.keyvault_environments["dev"].access_policies_objects
  custom_access_policies_objects = local.keyvault_environments["dev"].custom_access_policies_objects
  default_secrets_enabled        = local.keyvault_environments["dev"].default_secrets_enabled
  secrets                        = local.keyvault_environments["dev"].secrets
  secrets_to_create              = local.keyvault_environments["dev"].secrets_to_create

  tags = local.keyvault_environments["dev"].tags
  providers = {
    azurerm.dev = azurerm.dev
  }
  debug_outputs            = var.debug_outputs
  debug_sensitive_outputs  = var.debug_sensitive_outputs
  key_vault_dev_depends_on = local.keyvault_environments["dev"].depends_on

}
module "key_vault_stg" {
  source                        = "./key_vault/stg"
  env                           = "stg"
  key_vault_resource_group_name = local.keyvault_environments["stg"].key_vault_resource_group_name
  name                          = local.keyvault_environments["stg"].key_vault_name
  enabled_for_deployment        = local.keyvault_environments["stg"].enabled

  key_vault_sku_pricing_tier      = local.keyvault_environments["stg"].key_vault_sku_pricing_tier
  enabled_for_disk_encryption     = local.keyvault_environments["stg"].enabled_for_disk_encryption
  enabled_for_template_deployment = local.keyvault_environments["stg"].enabled_for_template_deployment
  soft_delete_retention_days      = local.keyvault_environments["stg"].soft_delete_retention_days
  enable_rbac_authorization       = local.keyvault_environments["stg"].enable_rbac_authorization
  purge_protection_enabled        = local.keyvault_environments["stg"].purge_protection_enabled

  network_acls                   = local.keyvault_environments["stg"].network_acls
  access_policies_objects        = local.keyvault_environments["stg"].access_policies_objects
  custom_access_policies_objects = local.keyvault_environments["stg"].custom_access_policies_objects
  default_secrets_enabled        = local.keyvault_environments["stg"].default_secrets_enabled
  secrets                        = local.keyvault_environments["stg"].secrets
  secrets_to_create              = local.keyvault_environments["stg"].secrets_to_create

  tags = local.keyvault_environments["stg"].tags

  # additional tags in label or
  # tags = merge({ "ResourceName" = lower("kv-${var.key_vault_name}") }, module.this.tags)

  # network_acls {
  #   default_action = "Allow"
  #   bypass         = "AzureServices"
  # }
  # dynamic "network_acls" {
  #   for_each = local.keyvault_environments["stg"].network_acls != null ? [true] : []
  #   content {
  #     bypass                     = local.keyvault_environments["stg"].network_acls.bypass
  #     default_action             = local.keyvault_environments["stg"].network_acls.default_action
  #     ip_rules                   = local.keyvault_environments["stg"].network_acls.ip_rules
  #     virtual_network_subnet_ids = local.keyvault_environments["stg"].network_acls.virtual_network_subnet_ids
  #   }
  # }

  providers = {
    azurerm.stg = azurerm.stg
  }
  debug_outputs            = var.debug_outputs
  debug_sensitive_outputs  = var.debug_sensitive_outputs
  key_vault_stg_depends_on = local.keyvault_environments["stg"].depends_on
}
module "key_vault_prd" {
  source                        = "./key_vault/prd"
  env                           = "prd"
  key_vault_resource_group_name = local.keyvault_environments["prd"].key_vault_resource_group_name
  name                          = local.keyvault_environments["prd"].key_vault_name
  enabled_for_deployment        = local.keyvault_environments["prd"].enabled

  key_vault_sku_pricing_tier      = local.keyvault_environments["prd"].key_vault_sku_pricing_tier
  enabled_for_disk_encryption     = local.keyvault_environments["prd"].enabled_for_disk_encryption
  enabled_for_template_deployment = local.keyvault_environments["prd"].enabled_for_template_deployment
  soft_delete_retention_days      = local.keyvault_environments["prd"].soft_delete_retention_days
  enable_rbac_authorization       = local.keyvault_environments["prd"].enable_rbac_authorization
  purge_protection_enabled        = local.keyvault_environments["prd"].purge_protection_enabled

  network_acls                   = local.keyvault_environments["prd"].network_acls
  access_policies_objects        = local.keyvault_environments["prd"].access_policies_objects
  custom_access_policies_objects = local.keyvault_environments["prd"].custom_access_policies_objects
  default_secrets_enabled        = local.keyvault_environments["prd"].default_secrets_enabled
  secrets                        = local.keyvault_environments["prd"].secrets
  secrets_to_create              = local.keyvault_environments["prd"].secrets_to_create

  tags = local.keyvault_environments["prd"].tags
  providers = {
    azurerm.prd = azurerm.prd
  }
  debug_outputs            = var.debug_outputs
  debug_sensitive_outputs  = var.debug_sensitive_outputs
  key_vault_prd_depends_on = local.keyvault_environments["prd"].depends_on

}
