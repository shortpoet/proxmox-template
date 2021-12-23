terraform {
  experiments = [module_variable_optional_attrs]
}
#################
# Labels/Common #
#################
variable "enabled_for_deployment" {
  type        = bool
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default     = true
}
variable "key_vault_application_name" {
  type        = string
  description = "This is the name of the application for the key vault. Must not be longer than 11 characters and only contains numbers, letters, and dashes."
  validation {
    condition     = length(replace(var.key_vault_application_name, "/[^a-zA-Z0-9-]/", "")) < 12
    error_message = "The key_vault_application_name must be less than 12 characters."
  }
}
variable "env" {
  type        = string
  description = <<-EOT
    The environment for this deployment.
    Possible values: `dev`, `stg`, `prd`.
    Default value: `dev`.
  EOT
  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "Allowed values: `dev`, `stg`, `prd`."
  }
}
variable "additional_kv_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    Evaluated last, these will override previous declarations in tags variable (evaluated first) and default
    {
    "DeploymentSubType" = "key_vault",
    "Environment"       = var.env
    } (evaluated second)   
    EOT
}
variable "additional_kv_secret_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    Evaluated last, these will override previous declarations in tags variable (evaluated first) and default
    {
    "DeploymentSubType" = "key_vault_secret",
    "Environment"       = var.env
    } (evaluated second)   
    EOT
}
variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources"
  default     = false
}

variable "debug_sensitive_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the sensitive variables resources"
  default     = false
}

#################################
# Azure Resource Group variable #
#################################

variable "key_vault_resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group"
}
#############################
# Azure Key Vault variables #
#############################
variable "key_vault_depends_on" {
  type    = any
  default = null
}
variable "key_vault_sku_pricing_tier" {
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}
variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys"
  default     = true
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted. The valid value can be between 7 and 90 days"
  default     = 90
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions"
  default     = false
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Is Purge Protection enabled for this Key Vault?"
  default     = false
}
variable "network_acls" {
  description = "Network rules to apply to key vault."
  type        = object({ bypass = string, default_action = string, ip_rules = list(string), virtual_network_subnet_ids = list(string) })
  default     = null
}

###################
# Access Policies #
###################
variable "admin_user" {
  type        = string
  description = "This is the admin user for the default policy. Added so that admin user has full access even when service principal creates the vault."
  default     = "csoriano@facilisgroup.com"
}
variable "access_policies_config_by_type" {
  type = object({
    key = object({
      read = list(string)
      full = list(string)
    })
    secret = object({
      read = list(string)
      full = list(string)
    })
    certificate = object({
      read = list(string)
      full = list(string)
    })
    storage = object({
      read = list(string)
      full = list(string)
    })
  })
  default = {
    key = {
      read = ["get", "list"]
      full = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
    }
    secret = {
      read = ["get", "list"]
      full = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
    }
    certificate = {
      read = ["get", "getissuers", "list", "listissuers"]
      full = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
    }
    storage = {
      read = ["get", "getsas", "list", "listsas"]
      full = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
    }
  }
}
variable "custom_access_policies_objects" {
  type = list(object({
    azure_ad_user_principal_name = string
    access = optional(object({
      key         = optional(list(string))
      secret      = optional(list(string))
      certificate = optional(list(string))
      storage     = optional(list(string))
    }))
  }))
  default = []
}
variable "access_policies_objects" {
  type = list(object({
    azure_ad_user_principal_name = string
    access = optional(object({
      key         = optional(string)
      secret      = optional(string)
      certificate = optional(string)
      storage     = optional(string)
    }))
  }))
  default = []
}
variable "sp_custom_access_policies_objects" {
  type = list(object({
    azure_ad_sp_display_name = optional(string)
    access = optional(object({
      key         = optional(list(string))
      secret      = optional(list(string))
      certificate = optional(list(string))
      storage     = optional(list(string))
    }))
  }))
  default = []
}
variable "sp_access_policies_objects" {
  type = list(object({
    azure_ad_sp_display_name = optional(string)
    access = optional(object({
      key         = optional(string)
      secret      = optional(string)
      certificate = optional(string)
      storage     = optional(string)
    }))
  }))
  default = []
}

###########
# Secrets #
###########

variable "secrets" {
  type        = map(string)
  description = <<-EOT
  A map of secrets for the Key Vault. Leave the value field blank for secret to be randomly generated.
  secrets = {
  "message" = "Hello, world!"
  }
  EOT
  default     = {}
}
variable "secrets_to_create" {
  type        = map(string)
  description = <<-EOT
  A map of secrets for the Key Vault with passwords to be created. Leave the value field blank for secret to be randomly generated.
  secrets_to_create = {
  "vmpass"  = ""
  }
  EOT
  default     = {}
}

variable "infra_vault_prefix" {
  type        = string
  description = "The prefix for the infrastruct vault `kv-sparq-infrastruct-$${module.this.environment}`. Defaults to kv-sparq-infrastruct"
  default     = "kv-sparq-infrastruct"
}
variable "default_secrets_enabled" {
  type        = bool
  description = "A flag whether to add service principal credentials taken from infra vault `kv-sparq-infrastruct-$${module.this.environment}`. Defaults to true"
  default     = true
}
variable "random_password_length" {
  description = "The desired length of random password created by this module"
  default     = 24
}
