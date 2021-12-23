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

###############################
# Service Principal Environments #
###############################

variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources"
  default     = false
}

variable "service_principal_environments" {
  type = object({
    stg = object({
      enabled       = bool
      debug_outputs = bool
      # azuread_application
      service_principal_name = string
      sign_in_audience       = string
      # azuread_service_principal
      alternative_names = optional(list(string))
      description       = optional(string)
      # time_rotating
      password_end_date          = optional(number)
      password_rotation_in_years = optional(number)
      password_rotation_in_days  = optional(number)
      # azuread_service_principal_password
      enable_service_principal_certificate = bool
      # azuread_service_principal_certificate
      certificate_type     = optional(string)
      certificate_encoding = optional(string)
      key_id               = optional(string)
      certificate_path     = optional(string)
      # azurerm_role_assignment
      azure_role_name        = optional(string)
      azure_role_description = optional(string)
      assignments = optional(list(object({
        scope                = string
        role_definition_name = string
      })))
      tags = optional(set(string))      
    })
    dev = object({
      enabled       = bool
      debug_outputs = bool
      # azuread_application
      service_principal_name = string
      sign_in_audience       = string
      # azuread_service_principal
      alternative_names = optional(list(string))
      description       = optional(string)
      # time_rotating
      password_end_date          = optional(number)
      password_rotation_in_years = optional(number)
      password_rotation_in_days  = optional(number)
      # azuread_service_principal_password
      enable_service_principal_certificate = bool
      # azuread_service_principal_certificate
      certificate_type     = optional(string)
      certificate_encoding = optional(string)
      key_id               = optional(string)
      certificate_path     = optional(string)
      # azurerm_role_assignment
      azure_role_name        = optional(string)
      azure_role_description = optional(string)
      assignments = optional(list(object({
        scope                = string
        role_definition_name = string
      })))
      tags = optional(set(string))      
    })
    prd = object({
      enabled       = bool
      debug_outputs = bool
      # azuread_application
      service_principal_name = string
      sign_in_audience       = string
      # azuread_service_principal
      alternative_names = optional(list(string))
      description       = optional(string)
      # time_rotating
      password_end_date          = optional(number)
      password_rotation_in_years = optional(number)
      password_rotation_in_days  = optional(number)
      # azuread_service_principal_password
      enable_service_principal_certificate = bool
      # azuread_service_principal_certificate
      certificate_type     = optional(string)
      certificate_encoding = optional(string)
      key_id               = optional(string)
      certificate_path     = optional(string)
      # azurerm_role_assignment
      azure_role_name        = optional(string)
      azure_role_description = optional(string)
      assignments = optional(list(object({
        scope                = string
        role_definition_name = string
      })))
      tags = optional(set(string))      
    })
  })
  default = {
    stg = {
      enabled                = true
      debug_outputs          = false
      service_principal_name = ""
      sign_in_audience       = "AzureADMyOrg"
      # azuread_service_principal_password
      enable_service_principal_certificate = false
      assignments                          = []
    }
    dev = {
      enabled                = true
      debug_outputs          = false
      service_principal_name = ""
      sign_in_audience       = "AzureADMyOrg"
      # azuread_service_principal_password
      enable_service_principal_certificate = false
      assignments                          = []
    }
    prd = {
      enabled                = true
      debug_outputs          = false
      service_principal_name = ""
      sign_in_audience       = "AzureADMyOrg"
      # azuread_service_principal_password
      enable_service_principal_certificate = false
      assignments                          = []
    }
  }
}

# default = {
#   stg = {
#     enabled                = true
#     debug_outputs = false
#     service_principal_name = null
#     # azuread_application
#     service_principal_name = null
#     sign_in_audience       = "AzureADMyOrg"
#     # azuread_service_principal
#     alternative_names = []
#     description       = null
#     # time_rotating
#     password_end_date          = null
#     password_rotation_in_years = null
#     rotation_days              = null
#     # azuread_service_principal_password
#     enable_service_principal_certificate = false
#     # azuread_service_principal_certificate
#     certificate_type     = null
#     certificate_encoding = "pem"
#     key_id               = null
#     certificate_path     = null
#     # azurerm_role_assignment
#     azure_role_name        = null
#     azure_role_description = null
#     assignments            = []
#   }
#   dev = {
#     enabled                = true
#     debug_outputs = false
#     service_principal_name = null
#     # azuread_application
#     service_principal_name = null
#     sign_in_audience       = "AzureADMyOrg"
#     # azuread_service_principal
#     alternative_names = []
#     description       = null
#     # time_rotating
#     password_end_date          = null
#     password_rotation_in_years = null
#     rotation_days              = null
#     # azuread_service_principal_password
#     enable_service_principal_certificate = false
#     # azuread_service_principal_certificate
#     certificate_type     = null
#     certificate_encoding = "pem"
#     key_id               = null
#     certificate_path     = null
#     # azurerm_role_assignment
#     azure_role_name        = null
#     azure_role_description = null
#     assignments            = []
#   }
#   prd = {
#     enabled                = true
#     debug_outputs = false
#     service_principal_name = null
#     # azuread_application
#     service_principal_name = null
#     sign_in_audience       = "AzureADMyOrg"
#     # azuread_service_principal
#     alternative_names = []
#     description       = null
#     # time_rotating
#     password_end_date          = null
#     password_rotation_in_years = null
#     rotation_days              = null
#     # azuread_service_principal_password
#     enable_service_principal_certificate = false
#     # azuread_service_principal_certificate
#     certificate_type     = null
#     certificate_encoding = "pem"
#     key_id               = null
#     certificate_path     = null
#     # azurerm_role_assignment
#     azure_role_name        = null
#     azure_role_description = null
#     assignments            = []
#   }
# }
