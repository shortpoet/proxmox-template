module "module_resource_group" {
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

variable "resource_group_name" {
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

###################################################
# Azure Resource Group (per env module) variables #
###################################################

##################################
# Variables Below By Environment #
##################################

# ################################
# Azure Resource Group variable #
# ################################

variable "enabled_for_deployment" {
  type = bool
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default = true
}

variable "resource_group_name" {
  type        = string
  description = "The name for the Resource Group"
}

variable "resource_group_location" {
  type        = string
  description = "The location for the Resource Group"
}

variable "resource_group_tags" {
  type        = map(string)
  description = "A map of tags passed in from calling/parent module."
  default     = null
}

variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources"
  default     = false
}

################
# Main Outputs #
################

output "ids" {
  value     = {
    stg = module.resource_group_stg.id
    dev = module.resource_group_dev.id
    prd = module.resource_group_prd.id
  }
  description = "A per-environment mapping of the ID of the Resource Group."
}

output "names" {
  value     = {
    stg = module.resource_group_stg.name
    dev = module.resource_group_dev.name
    prd = module.resource_group_prd.name
  }

  description = "A per-environment mapping of the name of the Resource Group."
}

output "locations" {
  value     = {
    stg = module.resource_group_stg.location
    dev = module.resource_group_dev.location
    prd = module.resource_group_prd.location
  }

  description = "A per-environment mapping of the location of the Resource Group."
}

#################
# Debug Outputs #
#################

output "tags" {
  value     = var.debug_outputs ? {
    stg = module.resource_group_stg.tags
    dev = module.resource_group_dev.tags
    prd = module.resource_group_prd.tags
  } : null

  description = "A per-environment mapping of the tags of the ."
}


#################################################
# Azure Resource Group (per env module) Outputs #
#################################################
output "id" {
  value       = azurerm_resource_group.main.id
  description = "The ID of the Resource Group."
}

output "name" {
  value       = azurerm_resource_group.main.name
  description = "The Name of the Resource Group."
}

output "location" {
  value       = azurerm_resource_group.main.location
  description = "The Name of the Resource Group."
}

#################
# Debug Outputs #
#################

output "tags" {
  value       = var.debug_outputs ? azurerm_resource_group.main.tags : null
  description = "The Name of the Resource Group."
}
