###################
# Terraform Cloud #
###################

##########################
# Terraform Organization #
##########################


variable "tfc_organization" {
  type        = string
  description = "This is the Terraform Cloud Organization to be used. This will most likely not change."
  default     = "sparq"
}

#######################
# Terraform Workspace #
#######################

variable "debug_outputs" {
  type        = bool
  description = "This is a flag to be able to print verbose outputs for the resources"
  default     = false
}

variable "workspace" {
  type        = string
  description = "Workspace for which to add variables."
  default     = null
}

variable "workspace_id" {
  type        = string
  description = "Workspace id. If supplied, this will override workspace."
  default     = null
}

variable "env" {
  type        = string
  description = "Environment."
  default     = null
}
variable "workspace_variables_dev_depends_on" {
  type    = any
  default = null
}
variable "workspace_variables_stg_depends_on" {
  type    = any
  default = null
}
variable "workspace_variables_prd_depends_on" {
  type    = any
  default = null
}

variable "key_vault_resource_group_name" {
  type        = string
  description = "The key vault resource group for this workspace. Used to determine the key vault from which to pull secrets for terraform cloud variables."
}

variable "key_vault_name" {
  type        = string
  description = "The key vault for this workspace. Used to pull secrets for terraform cloud variables."
}

variable "terraform_variables" {
  type = list(
    object({
      key         = string
      value       = string
      description = string
      type        = string
      sensitive   = bool
    })
  )

  validation {
    condition = alltrue([
      for variable in var.terraform_variables : variable.type == "PLAIN_TEXT" || variable.type == "KEY_VAULT"
    ])
    error_message = "All Terraform variables must have a type equal to either \"PLAIN_TEXT\" or \"KEY_VAULT\"."
  }

  default = []
}

variable "environment_variables" {
  type = list(
    object({
      key         = string
      value       = string
      description = string
      type        = string
      sensitive   = bool
    })
  )

  validation {
    condition = alltrue([
      for variable in var.environment_variables : variable.type == "PLAIN_TEXT" || variable.type == "KEY_VAULT"
    ])
    error_message = "All Environment variables must have a type equal to either \"PLAIN_TEXT\" or \"KEY_VAULT\"."
  }

  default = []
}