terraform {
  experiments = [module_variable_optional_attrs]
}

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

##########################
# Key Vault Environments #
##########################

variable "keyvault_environments" {
  type = object({
    stg = object({
      enabled                         = bool
      debug_outputs                   = bool
      debug_sensitive_outputs         = bool
      key_vault_resource_group_name   = string
      key_vault_name                  = string
      enabled_for_disk_encryption     = optional(bool)
      enabled_for_template_deployment = optional(bool)
      soft_delete_retention_days      = optional(number)
      enable_rbac_authorization       = optional(bool)
      purge_protection_enabled        = optional(bool)
      key_vault_sku_pricing_tier      = optional(string)
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
      secrets_to_create       = optional(map(string))
      default_secrets_enabled = bool
      depends_on              = any
    })
    dev = object({
      enabled                         = bool
      debug_outputs                   = bool
      debug_sensitive_outputs         = bool
      key_vault_resource_group_name   = string
      key_vault_name                  = string
      enabled_for_disk_encryption     = optional(bool)
      enabled_for_template_deployment = optional(bool)
      soft_delete_retention_days      = optional(number)
      enable_rbac_authorization       = optional(bool)
      purge_protection_enabled        = optional(bool)
      key_vault_sku_pricing_tier      = optional(string)
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
      secrets_to_create       = optional(map(string))
      default_secrets_enabled = bool
      depends_on              = any
    })
    prd = object({
      enabled                         = bool
      debug_outputs                   = bool
      debug_sensitive_outputs         = bool
      key_vault_resource_group_name   = string
      key_vault_name                  = string
      enabled_for_disk_encryption     = optional(bool)
      enabled_for_template_deployment = optional(bool)
      soft_delete_retention_days      = optional(number)
      enable_rbac_authorization       = optional(bool)
      purge_protection_enabled        = optional(bool)
      key_vault_sku_pricing_tier      = optional(string)
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
      secrets_to_create       = optional(map(string))
      default_secrets_enabled = bool
      depends_on              = any
    })
  })
  default = {
    stg = {
      debug_outputs                  = false
      debug_sensitive_outputs        = false
      default_secrets_enabled        = true
      enabled                        = true
      key_vault_resource_group_name  = null
      key_vault_name                 = null
      tags                           = null
      access_policies_objects        = null
      custom_access_policies_objects = null
      depends_on                     = null
    }
    dev = {
      debug_outputs                  = false
      debug_sensitive_outputs        = false
      default_secrets_enabled        = true
      enabled                        = true
      key_vault_resource_group_name  = null
      key_vault_name                 = null
      tags                           = null
      access_policies_objects        = null
      custom_access_policies_objects = null
      depends_on                     = null
    }
    prd = {
      debug_outputs                  = false
      debug_sensitive_outputs        = false
      default_secrets_enabled        = true
      enabled                        = true
      key_vault_resource_group_name  = null
      key_vault_name                 = null
      tags                           = null
      access_policies_objects        = null
      custom_access_policies_objects = null
      depends_on                     = null
    }
  }
}
# variable "workspace_environments" {
#   type = object({
#     stg = object({
#       enabled                         = bool
#       debug_outputs                   = bool
#       debug_sensitive_outputs         = bool
#       key_vault_resource_group_name   = string
#       key_vault_name                  = string
#       enabled_for_disk_encryption     = bool
#       enabled_for_template_deployment = bool
#       soft_delete_retention_days      = number
#       enable_rbac_authorization       = bool
#       purge_protection_enabled        = bool
#       key_vault_sku_pricing_tier      = string
#       network_acls = object({
#         bypass                     = string
#         default_action             = string
#         ip_rules                   = list(string)
#         virtual_network_subnet_ids = list(string)
#       })
#       tags = map(string)
#       access_policies = list(object({
#         azure_ad_user_principal_name = string
#         access_level                 = string
#         access_type                  = list(string)
#       }))
#       # https://github.com/kumarvna/terraform-azurerm-key-vault/blob/master/main.tf
#       # access_policies = list(object({
#       #   azure_ad_user_principal_names = list(string)
#       #   azure_ad_group_names          = list(string)
#       #   key_permissions               = list(string)
#       #   secret_permissions            = list(string)
#       #   certificate_permissions       = list(string)
#       #   storage_permissions           = list(string)
#       # }))
#       # https://github.com/claranet/terraform-azurerm-keyvault/blob/master/r-policies.tf
#       # https://github.com/guillermo-musumeci/terraform-azure-key-vault-module/blob/master/modules/keyvault/main.tf
#       # access_policies = map(object({
#       #   tenant_id               = string
#       #   object_id               = string
#       #   key_permissions         = list(string)
#       #   secret_permissions      = list(string)
#       #   certificate_permissions = list(string)
#       #   storage_permissions     = list(string)
#       # }))
#       random_password_length  = number
#       secrets                 = map(string)
#       default_secrets_enabled = bool
#     })
#   })
# }
