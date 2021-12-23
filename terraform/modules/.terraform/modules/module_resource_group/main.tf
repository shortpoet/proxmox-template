module "module_resource_group" {
  source = "./modules"
}

# This is only so that Terrform cloud picks up the inputs and outputs for auto-generated doc.

# MUST be an exact copy of variables and outputs.

#############
# Variables #
#############

terraform {
  experiments = [module_variable_optional_attrs]
}

# ################################
# Azure Resource Group variables #
# ################################

variable "enabled_for_deployment" {
  type = bool
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default = true
}

variable "env" {
  type        = string
  description = <<-EOT
    The environment for this deployment.
    Possible values: `dev`, `stg`, `prd`.
    Default value: `dev`.
  EOT
  validation {
    condition     = contains(["dev", "stg", "prd"], var.labelenv_key_case)
    error_message = "Allowed values: `dev`, `stg`, `prd`."
  }
}

variable "resource_group_location" {
  type        = string
  description = "The location for the Resource Group."
  default = "centralus"
}

variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources."
  default     = false
}

################
# Main Outputs #
################

#################################
# Azure Resource Group  Outputs #
#################################
output "id" {
  value       = azurerm_resource_group.main[*].id
  description = "The ID of the Resource Group."
}

output "name" {
  value       = azurerm_resource_group.main[*].name
  description = "The Name of the Resource Group."
}

output "location" {
  value       = azurerm_resource_group.main[*].location
  description = "The Name of the Resource Group."
}

#################
# Debug Outputs #
#################
output "tags" {
  value       = var.debug_outputs ? azurerm_resource_group.main[*].tags : null
  description = "The Name of the Resource Group."
}

