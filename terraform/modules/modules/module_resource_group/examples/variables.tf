terraform {
  experiments = [module_variable_optional_attrs]
}

########################
# Azure Authentication #
########################
variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id for this env."
}

# ################################
# Azure Resource Group variables #
# ################################
variable "enabled_for_deployment" {
  type        = bool
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default     = true
}
variable "application_name" {
  type        = string
  description = "This is the name of the application for the whole stack."
}
variable "resource_group_location" {
  type        = string
  description = "The location for the Resource Group."
  default     = "centralus"
}
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
variable "tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT  
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
variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources."
  default     = false
}
