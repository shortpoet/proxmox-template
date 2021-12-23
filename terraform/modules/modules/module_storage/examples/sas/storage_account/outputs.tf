output "storage_account_id" {
  description = "The ID of the storage account."
  value       = module.module_storage_account.storage_account_id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = module.module_storage_account.storage_account_name
}

output "storage_account_primary_location" {
  description = "The primary location of the storage account"
  value       = module.module_storage_account.storage_account_primary_location
}

output "storage_account_primary_web_endpoint" {
  description = "The endpoint URL for web storage in the primary location."
  value       = module.module_storage_account.storage_account_primary_web_endpoint
}

output "storage_account_primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = module.module_storage_account.storage_account_primary_web_host
}

output "storage_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = module.module_storage_account.storage_primary_connection_string
  sensitive   = true
}

output "storage_primary_access_key" {
  description = "The primary access key for the storage account"
  value       = module.module_storage_account.storage_primary_access_key
  sensitive   = true
}

output "storage_secondary_access_key" {
  description = "The primary access key for the storage account."
  value       = module.module_storage_account.storage_secondary_access_key
  sensitive   = true
}

output "containers" {
  description = "Map of containers."
  value       = module.module_storage_account.containers
}

output "file_shares" {
  description = "Map of Storage SMB file shares."
  value       = module.module_storage_account.file_shares
}

output "tables" {
  description = "Map of Storage SMB file shares."
  value       = module.module_storage_account.tables
}

output "queues" {
  description = "Map of Storage SMB file shares."
  value       = module.module_storage_account.queues
}

output "sas" {
  description = "SAS token"
  value       = module.module_storage_account.sas
  sensitive   = true
}
