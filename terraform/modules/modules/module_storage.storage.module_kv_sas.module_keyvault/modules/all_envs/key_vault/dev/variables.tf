terraform {
  experiments = [module_variable_optional_attrs]
}

##################################
# Variables Below By Environment #
##################################


# ##################################
# # Azure Resource Group variable #
# ##################################

variable "key_vault_resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group"
}

#############################
# Azure Key Vault variables #
#############################
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
variable "key_vault_dev_depends_on" {
  type    = any
  default = null
}

#####
# previously declared directly in context `module.this.id`
# now passed in from calling/parent module
variable "name" {
  type        = string
  description = "The name of the Azure Key Vault passed in from calling/parent module."
}
variable "tags" {
  type        = map(string)
  description = "A map of tags passed in from calling/parent module."
  default     = null
}
#####

variable "env" {
  type        = string
  description = "Environment."
  default     = null
}

variable "key_vault_sku_pricing_tier" {
  description = "The name of the SKU used for the Key Vault. The options are: `standard`, `premium`."
  default     = "standard"
}
variable "enabled_for_deployment" {
  type        = string
  description = "Allow Azure Virtual Machines to retrieve certificates stored as secrets from the Azure Key Vault"
  default     = "true"
}

variable "enabled_for_disk_encryption" {
  type        = string
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys"
  default     = "true"
}

variable "enabled_for_template_deployment" {
  type        = string
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
  default     = "true"
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. The valid value can be between 7 and 90 days"
  default     = 90
}

variable "enable_rbac_authorization" {
  description = "Specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions"
  default     = false
}

variable "purge_protection_enabled" {
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
    azure_ad_user_principal_name = optional(string)
    access = optional(object({
      key         = optional(list(string))
      secret      = optional(list(string))
      certificate = optional(list(string))
      storage     = optional(list(string))
    }))
  }))
  default = null
}
variable "access_policies_objects" {
  type = list(object({
    azure_ad_user_principal_name = optional(string)
    access = optional(object({
      key         = optional(string)
      secret      = optional(string)
      certificate = optional(string)
      storage     = optional(string)
    }))
  }))
  default = null
}
# variable "custom_access_policies_objects" {
#   type = optional(object({
#     user = optional(object({
#       azure_ad_user_principal_name = optional(string)
#       access = optional(object({
#         key         = optional(list(string))
#         secret      = optional(list(string))
#         certificate = optional(list(string))
#         storage     = optional(list(string))
#       }))
#     }))
#   }))
#   default = null
# }
# variable "access_policies_objects" {
#   type = optional(object({
#     user = optional(object({
#       azure_ad_user_principal_name = optional(string)
#       access = optional(object({
#         key         = optional(list(string))
#         secret      = optional(list(string))
#         certificate = optional(list(string))
#         storage     = optional(list(string))
#       }))
#     }))
#   }))
#   default = null
# }
# variable "access_policies_objects" {
#   type = map(object({
#     access = object({
#       key         = string
#       secret      = string
#       certificate = string
#       storage     = string
#     })
#   }))
#   default = null
# }

###########
# Secrets #
###########

variable "secrets" {
  type        = map(string)
  description = "A map of secrets for the Key Vault."
  default     = {}
}
variable "secrets_to_create" {
  type        = map(string)
  description = "A map of secrets for the Key Vault with passwords to be created."
  default     = {}
}

variable "default_secrets_enabled" {
  type        = bool
  description = "A flag whether to add service principal credentials taken from infra vault `kv-sparq-infra-$${module.this.environment}`. Defaults to true"
  default     = true
}
variable "random_password_length" {
  description = "The desired length of random password created by this module"
  default     = 24
}

###########################################
# Unused (Reference for possible changes) #
###########################################
# variable "kv_key_permissions_full" {
#   type = list(string)
#   default = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge",
#   "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
#   description = <<-EOT
#     "List of full key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey."
#   EOT
#   # validation might not be needed with default 
#   # can't get this to work for now
#   # validation {
#   #   condition     = contains(["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"], var.kv_key_permissions_full)
#   #   # condition     = var.kv_key_permissions_full == null ? true : contains(["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"], var.kv_key_permissions_full)
#   #   error_message = "Allowed values: `backup`, `create`, `decrypt`, `delete`, `encrypt`, `get`, `import`, `list`, `purge`, `recover`, `restore`, `sign`, `unwrapKey`, `update`, `verify`, `wrapKey`."
#   # }
# }
# variable "kv_secret_permissions_full" {
#   type        = list(string)
#   description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
#   default     = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
# }
# variable "kv_certificate_permissions_full" {
#   type        = list(string)
#   description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
#   default = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers",
#   "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
# }
# variable "kv_storage_permissions_full" {
#   type        = list(string)
#   description = "List of full storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
#   default = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas",
#   "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
# }
# variable "kv_key_permissions_read" {
#   type        = list(string)
#   description = "List of read key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
#   default     = ["get", "list"]
# }
# variable "kv_secret_permissions_read" {
#   type        = list(string)
#   description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
#   default     = ["get", "list"]
# }
# variable "kv_certificate_permissions_read" {
#   type        = list(string)
#   description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
#   default     = ["get", "getissuers", "list", "listissuers"]
# }
# variable "kv_storage_permissions_read" {
#   type        = list(string)
#   description = "List of read storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
#   default     = ["get", "getsas", "list", "listsas"]
# }
# variable "access_policies" {
#   type = list(object({
#     azure_ad_user_principal_name = string
#     access_level                 = list(string)
#     access_type                  = list(string)
#   }))
#   description = "Define an Azure Key Vault access policy"
#   default     = []
# }
# variable "access_policies_config_by_level" {
#   type = object({
#     full = object({
#       key         = list(string)
#       secret      = list(string)
#       certificate = list(string)
#       storage     = list(string)
#     })
#     read = object({
#       key         = list(string)
#       secret      = list(string)
#       certificate = list(string)
#       storage     = list(string)
#     })
#   })
#   default = {
#     full = {
#       key         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
#       secret      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
#       certificate = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
#       storage     = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
#     }
#     read = {
#       key         = ["get", "list"]
#       secret      = ["get", "list"]
#       certificate = ["get", "getissuers", "list", "listissuers"]
#       storage     = ["get", "getsas", "list", "listsas"]
#     }
#   }
# }
# variable "access_policies_objects" {
#   type = object({
#     name = object({
#       azure_ad_user_principal_name = string
#       access = object({
#         key         = list(string)
#         secret      = list(string)
#         certificate = list(string)
#         storage     = list(string)
#       })
#     })
#   })
#   default     = null
#   description = "Define an Azure Key Vault access policy"
# }
# variable "access_policies" {
#   description = "List of access policies for the Key Vault."
#   default     = []
# }

