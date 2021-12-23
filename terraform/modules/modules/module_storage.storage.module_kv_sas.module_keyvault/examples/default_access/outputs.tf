######
# RG #
######

output "rg_id" {
  value       = module.module_resource_group.id
  description = "The ID of the Resource Group."
}

output "rg_name" {
  value       = module.module_resource_group.name
  description = "The Name of the Resource Group."
}

output "rg_location" {
  value       = module.module_resource_group.location
  description = "The Name of the Resource Group."
}

#################
# Debug Outputs #
#################
output "rg_tags" {
  value       = var.debug_outputs ? module.module_resource_group.tags : null
  description = "The Name of the Resource Group."
}

######
# KV #
######
output "kv_id" {
  value       = module.module_key_vault.*.id
  description = "The ID of the Key Vault."
}

output "kv_name" {
  value       = module.module_key_vault.*.name
  description = "The name of the Key Vault."
}

output "kv_uri" {
  value       = module.module_key_vault.*.uri
  description = "The URI of the Key Vault."
}

output "kv_secrets" {
  value       = module.module_key_vault.*.secrets
  description = "A mapping of secret names and URIs."
}

output "kv_references" {
  value       = module.module_key_vault.*.references
  description = "A mapping of Key Vault references for App Service and Azure Functions."
}

#################
# Debug Outputs #
#################

output "kv_merged_local_secrets" {
  value     = var.debug_outputs ? module.module_key_vault.*.merged_local_secrets : null
  sensitive = true
}
output "kv_access_policies_local" {
  value = var.debug_outputs ? module.module_key_vault.*.access_policies_local : null
}

output "kv_access_policies_var" {
  value = var.debug_outputs ? module.module_key_vault.*.access_policies_var : null
}

output "kv_subscription_info" {
  value = var.debug_outputs ? {
    tenant_id       = module.module_key_vault.subscription_info.tenant_id
    subscription_id = module.module_key_vault.subscription_info.subscription_id
    object_id       = module.module_key_vault.subscription_info.object_id
    id              = module.module_key_vault.subscription_info.id
    client_id       = module.module_key_vault.subscription_info.client_id
    # https://registry.terraform.io/providers/hashicorp/azurerm/1.38.0/docs/data-sources/client_config
    # deprecated now available via object id
    # the following fields are only available when authenticating via a Service Principal (as opposed to using the Azure CLI) and have been deprecated:
    # service_principal_object_id = data.azurerm_client_config.client_config.service_principal_object_id
  } : null
}
