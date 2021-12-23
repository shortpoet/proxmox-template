module "storage" {
  source = "./modules"
}


# TODO consider making null value for env the condition for `enabled` for deployment
#################
# Labels/Common #
#################

variable "env" {
  type        = string
  default     = null
  description = <<-EOT
  #################
  # Labels/Common #
  #################

  The environment to which the resource stack will be deployed.
  EOT
}
variable "location" {
  type        = string
  default     = "centralus"
  description = "The location to which the resource stack will be deployed."
}

variable "application_name" {
  type        = string
  default     = "centralus"
  description = "The base name for the resource stack labels."
}

###########
# Storage #
###########
variable "resource_group_name" {
  type        = string
  default     = null
  description = <<-EOT
  ###########
  # Storage #
  ###########
  
  The name of the azure resource group to which the deployment stack belongs.
  EOT
}

variable "create_storage_account" {
  type        = bool
  default     = true
  description = "Whether to create a storage account."
}
variable "additional_st_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_account module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stct_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_container module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stfs_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_file_share module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stt_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_table module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stq_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_queue module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "account_kind" {
  description = "Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2`. Changing this forces a new resource to be created. Defaults to `StorageV2`"
  default     = "StorageV2"
}

variable "skuname" {
  description = <<-EOT
  The SKUs supported by Microsoft Azure Storage. Valid options are `Premium_LRS`, `Premium_ZRS`, `Standard_GRS`, `Standard_GZRS`, `Standard_LRS`, `Standard_RAGRS`, `Standard_RAGZRS`, `Standard_ZRS`. Defaults to `Standard_RAGRS` in module.
  Split to form:
  `account_tier` -> (Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created.
  and
  `account_replication_type` -> (Required) Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS`. Changing this forces a new resource to be created when types `LRS`, `GRS` and `RAGRS` are changed to `ZRS`, `GZRS` or `RAGZRS` and vice versa.
  EOT
  default     = "Standard_RAGRS"
}

variable "access_tier" {
  type        = string
  description = "(Optional) Defines the access tier for `BlobStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool`, defaults to `Hot`."
  default     = "Hot"
}

variable "min_tls_version" {
  description = "(Optional) The minimum supported TLS version for the storage account. Possible values are `TLS1_0`, `TLS1_1`, and `TLS1_2`. Defaults to `TLS1_0` for new storage accounts in provider and `TLS1_2` in module."
  default     = "TLS1_2"
}

variable "blob_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
}

variable "container_soft_delete_retention_days" {
  description = "Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
}

variable "enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = false
}

variable "last_access_time_enabled" {
  description = "Is the last access time based tracking enabled? Default to `false`"
  default     = false
}

variable "change_feed_enabled" {
  description = "Is the blob service properties for change feed events enabled?"
  default     = false
}

# container access_type `blob` requires public access to account -> `enable_advanced_threat_protection`
variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
}

variable "static_website" {
  description = "Static web site configuration. static_website can only be set when the account_kind is set to StorageV2 or BlockBlobStorage."
  type        = object({ index_document = string, error_404_document = string })
  default     = null
}

variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}

# container access_type `blob` requires public access to account -> `enable_advanced_threat_protection`
variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "file_shares" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}

variable "tables" {
  description = "List of storage tables."
  type        = list(string)
  default     = []
}

variable "queues" {
  description = "List of storages queues"
  type        = list(string)
  default     = []
}

variable "lifecycles" {
  description = "Configure Azure Storage firewalls and virtual networks"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}

variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`"
  default     = null
}

###########################
# Shared Access Signature #
###########################
variable "generate_sas_for_storage_account" {
  type        = bool
  default     = false
  description = <<-EOT
  ###########################
  # Shared Access Signature #
  ###########################

  Whether a sas token will be generated for the storage account or container."
  EOT
}

variable "generate_sas_for_storage_container" {
  type        = bool
  default     = false
  description = "Whether a sas token will be generated for the storage account or container."
}

variable "start" {
  description = "Start of SAS token validity. Defaults to now."
  type        = string
  //  validation {
  //    condition     = can(formatdate("", coalesce(var.start, timestamp())))
  //    error_message = "The start argument requires a valid RFC 3339 timestamp."
  //  }
  default = null
}

variable "rotation_days" {
  description = "How many days until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_hours" {
  description = "How many hours until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_minutes" {
  description = "How many minutes until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_months" {
  description = "How many months until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_years" {
  description = "How many years until a new token should be created. Exactly one of the rotation arguments should be given."
  type        = number
  default     = null
}

variable "rotation_margin" {
  type    = string
  default = "24h"
  //  validation {
  //    condition     = can(timeadd(timestamp(), var.rotation_margin))
  //    error_message = "The rotation_margin argument requires a valid duration."
  //  }
  description = "Margin to set on the validity of the SAS token. The SAS token remains valid for this duration after the moment that the rotation should take place. Syntax is the same as the timeadd() function."
}

variable "write" {
  description = "Collection of all writing-related permissions (includes creation and deletion)."
  type        = bool
  default     = true
}

variable "storage_container_name" {
  description = "Name of the storage container. Leave this empty to create a SAS token for the complete storage account."
  type        = string
  default     = null
}

#########################
# Key Vault Managed SAS #
#########################

variable "kv_manage_sas" {
  type        = bool
  default     = false
  description = <<-EOT
  #########################
  # Key Vault Managed SAS #
  #########################
  
  Whether a sas token will be managed by key vault.
  EOT
}
variable "is_service_principal" {
  type = bool
  description = "This determines whether the module is being run by a service principal."
  default = false
}
variable "sas_type" {
  type        = string
  default     = null
  description = "The type of SAS token the SAS definition will create. Possible values are account and service."
}
variable "key_vault_name" {
  description = "The name of the azure key vault in which to create and add the definition and sas token. If no key vault name is provided, the module will create one using label mdoule inputs."
  default     = null
}
variable "key_vault_resource_group_name" {
  description = "The name of the azure resource group for the key vault in which to create and add the definition and sas token."
  default     = null
}
variable "regeneration_validity_period" {
  description = "Validity and regeneration period of SAS token and definition. Value needs to be in ISO 8601 duration format. https://en.wikipedia.org/wiki/ISO_8601#Durations"
  type        = string
  default     = "P2D"
}
variable "additional_kv_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for key_vault label module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stmgmt_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for key_vault_managed_storage_account label module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stmgmtsasdef_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for key_vault_managed_storage_account_sas_token_definition label module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}


###########
# Outputs #
###########

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
