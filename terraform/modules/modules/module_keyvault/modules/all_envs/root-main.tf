module "module_keyvault" {
  source = "./modules"
}

# This is only so that Terrform cloud picks up the inputs and outputs for auto-generated doc.

# MUST be an exact copy of variables and outputs.

#############
# Variables #
#############

##################################
# Azure Resource Group variable #
##################################

variable "key_vault_resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group"
}

##################
# Main variables #
##################

########################
# Azure Authentication #
########################

# Azure Subscription Id
variable "azure_subscription_id_stg" {
  type = string
}
variable "azure_subscription_id_dev" {
  type = string
}
variable "azure_subscription_id_prd" {
  type = string
}

##########################
# Vars for local testing #
##########################

# variable "tags" {
#   type = map(string)
# }

# variable "key_vault_resource_group_name" {
#   type = string
# }

# variable "key_vault_name" {
#   type = string
# }

##########################
# Workspace Environments #
##########################

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
variable "custom_access_policies_objects" {
  type = object({
    user = object({
      azure_ad_user_principal_name = string
      access = object({
        key         = optional(list(string))
        secret      = optional(list(string))
        certificate = optional(list(string))
        storage     = optional(list(string))
      })
    })
  })
  default = null
}

variable "access_policies_objects" {
  type = map(object({
    access = object({
      key         = optional(list(string))
      secret      = optional(list(string))
      certificate = optional(list(string))
      storage     = optional(list(string))
    })
  }))
  default = null
}

variable "keyvault_environments" {
  type = object({
    stg = object({
      enabled                           = bool
      debug_outputs                     = bool
      debug_sensitive_outputs           = bool
      key_vault_resource_group_name     = string
      key_vault_name                    = string
      enabled_for_disk_encryption       = optional(bool)
      enabled_for_template_deployment   = optional(bool)
      soft_delete_retention_days        = optional(number)
      enable_rbac_authorization         = optional(bool)
      purge_protection_enabled          = optional(bool)
      key_vault_sku_pricing_tier        = optional(string)
      network_acls = optional(object({
        bypass                     = string
        default_action             = string
        ip_rules                   = list(string)
        virtual_network_subnet_ids = list(string)
      }))
      tags = map(string)
      custom_access_policies_objects = optional(list(object({
        azure_ad_user_principal_name = optional(string)
        access = optional(object({
          key         = optional(list(string))
          secret      = optional(list(string))
          certificate = optional(list(string))
          storage     = optional(list(string))
        }))
      })))
      access_policies_objects = optional(list(object({
        azure_ad_user_principal_name = optional(string)
        access = optional(object({
          key         = optional(string)
          secret      = optional(string)
          certificate = optional(string)
          storage     = optional(string)
        }))
      })))
      random_password_length  = optional(number)
      secrets                 = optional(map(string))
      default_secrets_enabled = bool
      depends_on              = any
    })
    dev = object({
      enabled                           = bool
      debug_outputs                     = bool
      debug_sensitive_outputs           = bool
      key_vault_resource_group_name     = string
      key_vault_name                    = string
      enabled_for_disk_encryption       = optional(bool)
      enabled_for_template_deployment   = optional(bool)
      soft_delete_retention_days        = optional(number)
      enable_rbac_authorization         = optional(bool)
      purge_protection_enabled          = optional(bool)
      key_vault_sku_pricing_tier        = optional(string)
      network_acls = optional(object({
        bypass                     = string
        default_action             = string
        ip_rules                   = list(string)
        virtual_network_subnet_ids = list(string)
      }))
      tags = map(string)
      custom_access_policies_objects = optional(list(object({
        azure_ad_user_principal_name = optional(string)
        access = optional(object({
          key         = optional(list(string))
          secret      = optional(list(string))
          certificate = optional(list(string))
          storage     = optional(list(string))
        }))
      })))
      access_policies_objects = optional(list(object({
        azure_ad_user_principal_name = optional(string)
        access = optional(object({
          key         = optional(string)
          secret      = optional(string)
          certificate = optional(string)
          storage     = optional(string)
        }))
      })))
      random_password_length  = optional(number)
      secrets                 = optional(map(string))
      default_secrets_enabled = bool
      depends_on              = any
    })
    prd = object({
      enabled                           = bool
      debug_outputs                     = bool
      debug_sensitive_outputs           = bool
      key_vault_resource_group_name     = string
      key_vault_name                    = string
      enabled_for_disk_encryption       = optional(bool)
      enabled_for_template_deployment   = optional(bool)
      soft_delete_retention_days        = optional(number)
      enable_rbac_authorization         = optional(bool)
      purge_protection_enabled          = optional(bool)
      key_vault_sku_pricing_tier        = optional(string)
      network_acls = optional(object({
        bypass                     = string
        default_action             = string
        ip_rules                   = list(string)
        virtual_network_subnet_ids = list(string)
      }))
      tags = map(string)
      custom_access_policies_objects = optional(list(object({
        azure_ad_user_principal_name = optional(string)
        access = optional(object({
          key         = optional(list(string))
          secret      = optional(list(string))
          certificate = optional(list(string))
          storage     = optional(list(string))
        }))
      })))
      access_policies_objects = optional(list(object({
        azure_ad_user_principal_name = optional(string)
        access = optional(object({
          key         = optional(string)
          secret      = optional(string)
          certificate = optional(string)
          storage     = optional(string)
        }))
      })))
      random_password_length  = optional(number)
      secrets                 = optional(map(string))
      default_secrets_enabled = bool
      depends_on              = any
    })
  })
  default = {
    stg = {
      debug_outputs                     = false
      debug_sensitive_outputs           = false
      default_secrets_enabled           = true
      enabled                           = true
      key_vault_resource_group_name     = null
      key_vault_name                    = null
      tags                              = null
      access_policies_objects           = null
      custom_access_policies_objects    = null
      depends_on                        = null
    }
    dev = {
      debug_outputs                     = false
      debug_sensitive_outputs           = false
      default_secrets_enabled           = true
      enabled                           = true
      key_vault_resource_group_name     = null
      key_vault_name                    = null
      tags                              = null
      access_policies_objects           = null
      custom_access_policies_objects    = null
      depends_on                        = null
    }
    prd = {
      debug_outputs                     = false
      debug_sensitive_outputs           = false
      default_secrets_enabled           = true
      enabled                           = true
      key_vault_resource_group_name     = null
      key_vault_name                    = null
      tags                              = null
      access_policies_objects           = null
      custom_access_policies_objects    = null
      depends_on                        = null
    }
  }
}

##############################################
# Azure Key Vault (per env module) variables #
##############################################

# declared in context `module.this.id`
# variable "name" {
#   type        = string
#   description = "The name of the Azure Key Vault"
# }

##################################
# Variables Below By Environment #
##################################


# ##################################
# # Azure Resource Group variable #
# ##################################

variable "resource_group_name" {
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
variable "key_vault_stg_depends_on" {
  type    = any
  default = null
}
variable "key_vault_dev_depends_on" {
  type    = any
  default = null
}
variable "key_vault_prd_depends_on" {
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

################
# Main Outputs #
################

output "ids" {
  value = {
    stg = module.key_vault_stg.id
    dev = module.key_vault_dev.id
    prd = module.key_vault_prd.id
  }
  description = "A per-environment mapping of the ID of the Key Vault."
}

output "names" {
  value = {
    stg = module.key_vault_stg.name
    dev = module.key_vault_dev.name
    prd = module.key_vault_prd.name
  }

  description = "A per-environment mapping of the name of the Key Vault."
}

output "uris" {
  value = {
    stg = module.key_vault_stg.uri
    dev = module.key_vault_dev.uri
    prd = module.key_vault_prd.uri
  }
  description = "A per-environment mapping of the URI of the Key Vault."
}

output "secrets" {
  value = {
    stg = module.key_vault_stg.secrets
    dev = module.key_vault_dev.secrets
    prd = module.key_vault_prd.secrets
  }

  description = "A per-environment mapping of secret names and URIs."
}

output "references" {
  value = {
    stg = module.key_vault_stg.references
    dev = module.key_vault_dev.references
    prd = module.key_vault_prd.references
  }

  description = "A per-environment mapping of Key Vault references for App Service and Azure Functions."
}

#################
# Debug Outputs #
#################

output "workspace_environments_local" {
  value = var.debug_outputs ? local.workspace_environments : null
}
output "workspace_environments_var" {
  value = var.debug_outputs ? var.workspace_environments : null
}
output "merged_local_secrets" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.merged_local_secrets
    dev = module.key_vault_dev.merged_local_secrets
    prd = module.key_vault_prd.merged_local_secrets
  } : null
  sensitive = true
}
output "access_policies_local" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.access_policies_local
    dev = module.key_vault_dev.access_policies_local
    prd = module.key_vault_prd.access_policies_local
  } : null
}
output "access_policies_var" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.access_policies_var
    dev = module.key_vault_dev.access_policies_var
    prd = module.key_vault_prd.access_policies_var
  } : null

}
output "sub_info" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.sub_info
    dev = module.key_vault_dev.sub_info
    prd = module.key_vault_prd.sub_info
  } : null

}

############################################
# Azure Key Vault (per env module) Outputs #
############################################
output "id" {
  value       = azurerm_key_vault.main.id
  description = "The ID of the Key Vault."
}

output "name" {
  value       = azurerm_key_vault.main.name
  description = "The name of the Key Vault."
}

output "uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "The URI of the Key Vault."
}

output "secrets" {
  value       = { for k, v in azurerm_key_vault_secret.main : v.name => v.id }
  description = "A mapping of secret names and URIs."
}

output "references" {
  value = {
    for k, v in azurerm_key_vault_secret.main :
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
  value = var.debug_outputs ? concat(var.custom_access_policies_objects, var.access_policies_objects) : null
}

output "sub_info" {
  value = var.debug_outputs ? {
    tenant_id = data.azurerm_client_config.main.tenant_id
    sub_id    = data.azurerm_client_config.main.subscription_id
    object_id = data.azurerm_client_config.main.object_id
    id        = data.azurerm_client_config.main.id
    client_id = data.azurerm_client_config.main.client_id
    # https://registry.terraform.io/providers/hashicorp/azurerm/1.38.0/docs/data-sources/client_config
    # deprecated now available via object id
    # the following fields are only available when authenticating via a Service Principal (as opposed to using the Azure CLI) and have been deprecated:
    # service_principal_object_id = data.azurerm_client_config.main.service_principal_object_id
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
