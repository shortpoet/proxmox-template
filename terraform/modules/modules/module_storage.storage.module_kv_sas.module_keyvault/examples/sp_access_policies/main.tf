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
############################
# Service Principal Module #
############################

module "module_service_principal" {
  count = 2
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_service_principal/azure//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  debug_outputs              = false
  enabled_for_deployment     = var.enabled_for_deployment
  application_name           = "${var.application_name}-${count.index}"
  service_principal_location = var.service_principal_location
  env                        = var.env
  sign_in_audience           = "AzureADMyOrg"
  description                = "This is service principal number-${count.index} to test the key vault module in the ${var.env} environment."
  password_rotation_in_years = var.password_rotation_in_years
  # Adding roles and scope to service principal
  assignments = [
    {
      scope                = "/subscriptions/${var.azure_subscription_id}"
      role_definition_name = "Contributor"
    }
  ]
  # azuread_service_principal_password
  enable_service_principal_certificate = false
  sp_tags                              = var.sp_tags
}
locals {
  access_policies_objects = concat(var.access_policies_objects, [
    {
      azure_ad_object_id = module.module_service_principal[0].service_principal_object_id[0]
      access = {
        key         = null
        secret      = "read"
        certificate = null
        storage     = null
      }
    }
  ])
  custom_access_policies_objects = concat(var.custom_access_policies_objects, [
    {
      azure_ad_object_id = module.module_service_principal[1].service_principal_object_id[0]
      access = {
        key         = ["get", "import", "list", "sign", "unwrapKey", "update", "verify", "wrapKey"]
        secret      = ["get", "list", "purge", "recover", "restore", "set"]
        certificate = ["create", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers"]
        storage     = ["get", "getsas", "list", "listsas"]
      }
    }
  ])
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
  access_policies_objects        = local.access_policies_objects
  custom_access_policies_objects = local.custom_access_policies_objects

  default_secrets_enabled = var.default_secrets_enabled
  secrets                 = var.secrets
  secrets_to_create       = var.secrets_to_create

  tags                      = var.tags
  additional_kv_tags        = var.additional_kv_tags
  additional_kv_secret_tags = var.additional_kv_secret_tags
  debug_outputs             = var.debug_outputs
  debug_sensitive_outputs   = var.debug_sensitive_outputs
  key_vault_depends_on = [
    module.module_resource_group,
    module.module_service_principal
  ]
}
