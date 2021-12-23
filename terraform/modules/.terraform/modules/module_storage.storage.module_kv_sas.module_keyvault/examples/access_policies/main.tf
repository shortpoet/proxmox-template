module "module_resource_group" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_resource_group/azure//modules"
  version = "0.1.0"
  ############
  enabled_for_deployment  = var.enabled_for_deployment
  application_name        = var.application_name
  resource_group_location = var.resource_group_location
  env                     = var.env
  tags                    = var.tags
  additional_rg_tags      = var.additional_rg_tags
}

module "module_key_vault" {
  source                        = "../../modules"
  enabled_for_deployment        = var.enabled_for_deployment
  key_vault_application_name    = var.application_name
  key_vault_resource_group_name = module.module_resource_group.name[0]
  env                           = var.env

  # key_vault_sku_pricing_tier      = var.key_vault_sku_pricing_tier
  # enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  # enabled_for_template_deployment = var.enabled_for_template_deployment
  # soft_delete_retention_days      = var.soft_delete_retention_days
  # enable_rbac_authorization       = var.enable_rbac_authorization
  # purge_protection_enabled        = var.purge_protection_enabled

  # network_acls                   = var.network_acls
  access_policies_objects        = var.access_policies_objects
  custom_access_policies_objects = var.custom_access_policies_objects

  default_secrets_enabled = var.default_secrets_enabled
  secrets                 = var.secrets
  secrets_to_create       = var.secrets_to_create

  tags                      = var.tags
  additional_kv_tags        = var.additional_kv_tags
  additional_kv_secret_tags = var.additional_kv_secret_tags
  debug_outputs             = var.debug_outputs
  debug_sensitive_outputs   = var.debug_sensitive_outputs
  key_vault_depends_on = [
    module.module_resource_group
  ]
}
