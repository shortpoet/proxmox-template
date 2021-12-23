variable "azure_subscription_id" {
  type        = string
  default     = null
  description = "The Azure Subscription Id to which the resource stack will be deployed."
}

#############
# Env / App #
#############
variable "env" {
  type        = string
  default     = "dev"
  description = <<-EOT
  The environment to which the resource stack will be deployed.
  Possible values: `dev`, `stg`, `prd`.
  Default value: `dev`.
  EOT
  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "Allowed values: `dev`, `stg`, `prd`."
  }
}
variable "rg_application_name" {
  type        = string
  description = "This is the name of the application for the resource group."
}
variable "storage_application_name" {
  type        = string
  description = "The base name for the storage labels."
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
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default     = true
}
variable "resource_group_location" {
  type        = string
  description = "The location for the resource group and to which the resource stack will be deployed."
  default     = "centralus"
}
variable "additional_rg_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    Evaluated last, these will override previous declarations in tags variable (evaluated first) and default
    {
    "DeploymentSubType" = "resource_group",
    "Environment"       = var.env
    } (evaluated second)   
    EOT
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_st_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_account module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
# container access_type `blob` requires public access to account -> `enable_advanced_threat_protection`
variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
}
variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  default     = null
}

#############
# Container #
#############
variable "containers_list" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

variable "additional_stct_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_container module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}

#############
# SAS Token #
#############
variable "generate_sas_for_storage_account" {
  type        = bool
  default     = false
  description = "Whether a sas token will be generated for the storage account or container."
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
variable "key_vault_depends_on" {
  type    = any
  default = null
}
variable "kv_manage_sas" {
  type        = bool
  default     = false
  description = "Whether a sas token will be managed by key vault."
}
variable "sas_type" {
  type        = string
  default     = null
  description = "The type of SAS token the SAS definition will create. Possible values are account and service."
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

