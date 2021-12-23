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

variable "storage_application_name" {
  type        = string
  description = "The base name for the storage labels."
  validation {
    condition     = length(var.storage_application_name) < 18
    error_message = "The key_vault_application_name must be less than 18 characters. Azure -> name can only consist of lowercase letters and numbers, and must be between 3 and 24 characters long."
  }
}
variable "key_vault_application_name" {
  type        = string
  description = "This is the name of the application for the key vault. Must not be longer than 11 characters and only contains numbers, letters, and dashes."
  validation {
    condition     = length(replace(var.key_vault_application_name, "/[^a-zA-Z0-9-]/", "")) < 12
    error_message = "The key_vault_application_name must be less than 12 characters."
  }
}
variable "enabled_for_deployment" {
  type        = bool
  description = "Whether or not to create the resource."
  default     = true
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
variable "sp_object_id" {
  type        = string
  default     = null
  description = "The object id of the service principal if one is to be added to key vault custom access policies."
}
variable "sas_template_uri" {
  type        = string
  default     = null
  description = "The SAS definition token template signed with an arbitrary key. Tokens created according to the SAS definition will have the same properties as the template, but regenerated with a new validity period."
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

