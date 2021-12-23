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
#################
# Labels/Common #
#################
variable "enabled_for_deployment" {
  type        = bool
  description = "Whether or not to create the resource. Defaults to true because we generally want to create resource groups and there is no cost."
  default     = true
}
variable "application_name" {
  type        = string
  description = "This is the name of the application for the whole stack."
}
variable "service_principal_location" {
  type        = string
  description = "The location for the Resource Group."
  default     = "centralus"
}

variable "env" {
  type        = string
  description = <<-EOT
    The environment for this deployment.
    Possible values: `dev`, `stg`, `prd`.
    Default value: `dev`.
  EOT
  validation {
    condition     = contains(["dev", "stg", "prd"], var.env)
    error_message = "Allowed values: `dev`, `stg`, `prd`."
  }
}
variable "sp_tags" {
  type        = set(string)
  description = "A set of string tags."
  default     = []
}
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

#####################################
# Azure Service Principal variables #
#####################################
variable "sign_in_audience" {
  description = "The Microsoft account types that are supported for the current application. Must be one of `AzureADMyOrg`, `AzureADMultipleOrgs`, `AzureADandPersonalMicrosoftAccount` or `PersonalMicrosoftAccount`"
  default     = "AzureADMyOrg"
}
variable "alternative_names" {
  type        = list(string)
  description = "A set of alternative names, used to retrieve service principals by subscription, identify service principal and full resource ids for managed identities."
  default     = []
}
variable "description" {
  description = "A description of the service principal provided for internal end-users."
  default     = null
}
variable "role_definition_name" {
  description = "The name of a Azure built-in Role for the service principal"
  default     = null
}
variable "password_end_date" {
  description = "The relative duration or RFC3339 rotation timestamp after which the password expire"
  default     = null
}
variable "password_rotation_in_years" {
  description = "Number of years to add to the base timestamp to configure the password rotation timestamp. Conflicts with password_end_date and either one is specified and not the both"
  default     = null
}

variable "password_rotation_in_days" {
  description = "Number of days to add to the base timestamp to configure the rotation timestamp. When the current time has passed the rotation timestamp, the resource will trigger recreation.Conflicts with `password_end_date`, `password_rotation_in_years` and either one must be specified, not all"
  default     = null
}
variable "enable_service_principal_certificate" {
  description = "Manages a Certificate associated with a Service Principal within Azure Active Directory"
  default     = false
}
variable "certificate_encoding" {
  description = "Specifies the encoding used for the supplied certificate data. Must be one of `pem`, `base64` or `hex`"
  default     = "pem"
}
variable "key_id" {
  description = "A UUID used to uniquely identify this certificate. If not specified a UUID will be automatically generated."
  default     = null
}
variable "certificate_type" {
  description = "The type of key/certificate. Must be one of AsymmetricX509Cert or Symmetric"
  default     = "AsymmetricX509Cert"
}
variable "certificate_path" {
  description = "The path to the certificate for this Service Principal"
  default     = ""
}
variable "azure_role_name" {
  description = "A unique UUID/GUID for this Role Assignment - one will be generated if not specified."
  default     = null
}
variable "azure_role_description" {
  description = "The description for this Role Assignment"
  default     = null
}
variable "custom_roles" {
  description = "The list of custom roles to create."
  type = list(object({
    name        = string
    description = string
    permissions = object({
      actions          = optional(list(string))
      not_actions      = optional(list(string))
      data_actions     = optional(list(string))
      not_data_actions = optional(list(string))
    })
    assignable_scopes = list(string)
  }))
  default = []
}
variable "custom_roles_json" {
  description = "The list of custom roles to create in format for az cli."
  type = list(object({
    Name             = string
    Description      = string
    Actions          = optional(list(string))
    NotActions       = optional(list(string))
    DataActions      = optional(list(string))
    NotDataActions   = optional(list(string))
    AssignableScopes = list(string)
  }))
  default = []
}
variable "role_definition_file" {
  description = "The path and file name of the role definition file to be used."
  type        = string
  default     = null
}
variable "assignments" {
  description = "The list of role assignments to this service principal."
  type = list(object({
    scope                = string
    role_definition_name = string
  }))
  default = []
}
variable "custom_assignments" {
  description = "The list of custom role assignments to this service principal."
  type = list(object({
    scope                = string
    role_definition_name = string
    description          = string
  }))
  default = []
}