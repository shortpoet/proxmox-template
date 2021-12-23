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

