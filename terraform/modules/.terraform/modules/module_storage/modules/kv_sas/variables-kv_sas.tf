# labels

variable "env" {
  type        = string
  default     = null
  description = "The environment to which the resource stack will be deployed."
}
variable "key_vault_application_name" {
  type        = string
  description = "This is the name of the application for the key vault. Must not be longer than 11 characters and only contains numbers, letters, and dashes."
  validation {
    condition     = length(replace(var.key_vault_application_name, "/[^a-zA-Z0-9-]/", "")) < 12
    error_message = "The key_vault_application_name must be less than 12 characters."
  }
}
variable "storage_application_name" {
  type        = string
  description = "The base name for the storage labels."
}
variable "enabled_for_deployment" {
  type        = bool
  description = "Whether or not to create the resource."
  default     = true
}

# key vault

variable "location" {
  type        = string
  default     = "centralus"
  description = "The location to which the resource stack will be deployed."
}
variable "resource_group_name" {
  description = "The name of the azure resource group to which the deployment stack belongs."
}
variable "key_vault_name" {
  description = "The name of the azure key vault in which to create and add the definition and sas token. If no key vault name is provided, the module will create one using label mdoule inputs."
  default     = null
}
variable "key_vault_resource_group_name" {
  description = "The name of the azure resource group for the key vault in which to create and add the definition and sas token."
  default     = null
}
variable "additional_kv_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for key_vault module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
# storage account

variable "storage_account_id" {
  type        = string
  default     = "centralus"
  description = "The storage account id."
}
variable "storage_account_name" {
  type        = string
  default     = "centralus"
  description = "The storage account name."
}

# management
variable "sp_object_id" {
  type        = string
  default     = null
  description = "The object id of the service principal if one is to be added to key vault custom access policies."
}
variable "sas_template_uri" {
  type        = string
  default     = null
  description = "The SAS definition token template signed with an arbitrary key. Tokens created according to the SAS definition will have the same properties as the template, but regenerated with a new validity period."
}
variable "sas_type" {
  type        = string
  default     = null
  description = "The type of SAS token the SAS definition will create. Possible values are account and service."
}
variable "regeneration_validity_period" {
  description = "Validity and regeneration period of SAS token and definition. Value needs to be in ISO 8601 duration format. https://en.wikipedia.org/wiki/ISO_8601#Durations"
  type        = string
  default     = "P2D"
}
variable "additional_stmgmt_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for key_vault_managed_storage_account module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
variable "additional_stmgmtsasdef_tags" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Additional tags for key_vault_managed_storage_account_sas_token_definition module (e.g. `{'BusinessUnit': 'XYZ'}`).
    Neither the tag keys nor the tag values will be modified by this module.
    EOT
}
