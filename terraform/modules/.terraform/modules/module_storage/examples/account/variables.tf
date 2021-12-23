variable "azure_subscription_id" {
  type        = string
  description = "The Azure Subscription Id to which the resource stack will be deployed."
}
#############
# Env / App #
#############
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
variable "enabled_for_deployment" {
  type        = bool
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default     = true
}
variable "resource_group_location" {
  type        = string
  description = "The location for the Resource Group."
  default     = "centralus"
}
variable "rg_application_name" {
  type        = string
  description = "This is the name of the application for the resource group."
}
variable "storage_application_name" {
  type        = string
  description = "The base name for the storage labels."
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
variable "additional_st_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_account module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stct_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_container module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stfs_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_file_share module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stt_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_table module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stq_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for storage_queue module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}

