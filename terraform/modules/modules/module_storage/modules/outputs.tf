output "storage_account_id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.st_account.*.id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.st_account.*.name
}

output "storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = azurerm_storage_account.st_account.*.primary_location
}

output "storage_account_primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location."
  value       = azurerm_storage_account.st_account.*.primary_web_endpoint
}

output "storage_account_primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = azurerm_storage_account.st_account.*.primary_web_host
}

output "storage_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.st_account.*.primary_connection_string
  sensitive   = true
}

output "storage_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.st_account.*.primary_access_key
  sensitive   = true
}

output "storage_secondary_access_key" {
  description = "The primary access key for the storage account."
  value       = azurerm_storage_account.st_account.*.secondary_access_key
  sensitive   = true
}

output "containers" {
  description = "Map of containers."
  value       = { for c in azurerm_storage_container.st_container.* : c.name => c.id }
}

output "file_shares" {
  description = "Map of Storage SMB file shares."
  value       = { for f in azurerm_storage_share.storage_share.* : f.name => f.id }
}

output "tables" {
  description = "Map of Storage SMB file shares."
  value       = { for t in azurerm_storage_table.st_table.* : t.name => t.id }
}

output "queues" {
  description = "Map of Storage SMB file shares."
  value       = { for q in azurerm_storage_queue.st_queue.* : q.name => q.id }
}

output "sas" {
  description = "SAS token"
  value       = module.module_sas.*.sas
  sensitive   = true
}

output "kv_sas_id" {
  description = "The ID of the Key Vault Managed Storage Account."
  value       = module.module_kv_sas.*.kv_sas_id
}

output "kv_sas_definition_id" {
  description = "The ID of the Managed Storage Account SAS Definition."
  value       = module.module_kv_sas.*.kv_sas_definition_id
}

output "kv_sas_secret_id" {
  description = "The ID of the Secret that is created by Managed Storage Account SAS Definition."
  value       = module.module_kv_sas.*.kv_sas_secret_id
}