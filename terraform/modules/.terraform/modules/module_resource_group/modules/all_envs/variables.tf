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
# Resource Group Environments #
###############################

variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources"
  default     = false
}
variable "resource_group_environments" {
  type = object({
    stg = object({
      enabled                 = bool
      resource_group_name     = string
      resource_group_location = string
      debug_outputs           = bool
      resource_group_tags     = map(string)
    })
    dev = object({
      enabled                 = bool
      resource_group_name     = string
      resource_group_location = string
      debug_outputs           = bool
      resource_group_tags     = map(string)
    })
    prd = object({
      enabled                 = bool
      resource_group_name     = string
      resource_group_location = string
      debug_outputs           = bool
      resource_group_tags     = map(string)
    })
  })
  default = {
    stg = {
      enabled                 = true
      resource_group_name     = null
      resource_group_location = null
      debug_outputs           = false
      resource_group_tags     = null
    }
    dev = {
      enabled                 = true
      resource_group_name     = null
      resource_group_location = null
      debug_outputs           = false
      resource_group_tags     = null
    }
    prd = {
      enabled                 = true
      resource_group_name     = null
      resource_group_location = null
      debug_outputs           = false
      resource_group_tags     = null
    }
  }
}
