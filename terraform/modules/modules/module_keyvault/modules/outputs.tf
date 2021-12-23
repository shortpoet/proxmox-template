
output "id" {
  value       = azurerm_key_vault.kv.*.id
  description = "The ID of the Key Vault."
}

output "name" {
  value       = azurerm_key_vault.kv.*.name
  description = "The name of the Key Vault."
}

output "uri" {
  value       = azurerm_key_vault.kv.*.vault_uri
  description = "The URI of the Key Vault."
}

output "secrets" {
  value       = { for k, v in azurerm_key_vault_secret.kv_secret : v.name => v.id }
  description = "A mapping of secret names and URIs."
}

output "references" {
  value = {
    for k, v in azurerm_key_vault_secret.kv_secret :
    v.name => format("@Microsoft.KeyVault(SecretUri=%s)", v.id)
  }
  description = "A mapping of Key Vault references for App Service and Azure Functions."
}

#################
# Debug Outputs #
#################

output "merged_local_secrets" {
  value     = var.debug_outputs ? local.secrets : null
  sensitive = true
}
output "access_policies_local" {
  value = var.debug_outputs ? local.access_policies : null
}

output "access_policies_var" {
  value = var.debug_outputs ? try(concat(local.custom_access_policies_objects, local.access_policies_objects), null) : null
}

output "subscription_info" {
  value = var.debug_outputs ? {
    tenant_id       = data.azurerm_client_config.client_config.tenant_id
    subscription_id = data.azurerm_client_config.client_config.subscription_id
    object_id       = data.azurerm_client_config.client_config.object_id
    id              = data.azurerm_client_config.client_config.id
    client_id       = data.azurerm_client_config.client_config.client_id
    # https://registry.terraform.io/providers/hashicorp/azurerm/1.38.0/docs/data-sources/client_config
    # deprecated now available via object id
    # the following fields are only available when authenticating via a Service Principal (as opposed to using the Azure CLI) and have been deprecated:
    # service_principal_object_id = data.azurerm_client_config.client_config.service_principal_object_id
  } : null
}

###########################################
# Unused (Reference for possible changes) #
###########################################
# output "group_object_ids" {
#   value = local.group_object_ids
# }

# output "user_object_ids" {
#   value = local.user_object_ids
# }
