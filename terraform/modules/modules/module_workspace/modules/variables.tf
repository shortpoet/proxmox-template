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
# variable "tfc_workspace_id" {
#   type = string
#   description = "This is the id of the Terraform Cloud Workspace to be used."
#   default = ""
# }
variable "tfc_ssh_key_name" {
  type        = string
  description = "This is the name of the Terraform Cloud ssh key to be used."
  default     = ""
}
variable "oauth_token_id" {
  description = "Id of Terraform Cloud OAuth connection to use. This most likely will not change considering we have a single machine user."
  type        = string
}

#######################
# Terraform Workspace #
#######################

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


variable "TFC_WORKSPACE_NAME" {
  type    = string
  default = "" # An error occurs when you are running TF backend other than Terraform Cloud
}

variable "workspace_prefix" {
  type        = string
  description = "This is the prefix for all the environment-specific workspaces for this repo. e.g. `mod-sparq-terraform_test-centralus`. Don't use a dash at the end like in the backend config. You can interpolate without it but syntax highlighting is borked if so e.g. `$${var.workspace_prefix}$${env}`."
}

variable "working_directory" {
  type        = string
  description = "VCS working directory for workspaces. Can be used to override individual environment working directory. Defaults to null."
  default     = null
}

# TODO use some validation and/or scripting to automate this throughout all modules - perhaps using AzDO pipeline
variable "terraform_version" {
  type        = string
  description = "The default terraform version to use. Should match version in all versions files."
  default     = "1.0.9"
}

##########################
# Workspace Environments #
##########################
# possible merge of defaults as in
# https://github.com/hashicorp/terraform/issues/15966
# defaults = object({
#   location         = string
#   application_name = string
#   debug_outputs    = string
#   tfc_environment_variables = object({
#     azure_subscription_id = string
#   })
# })

# TODO rename as keyvault_resource_group_prefix
variable "key_vault_resource_group_prefix" {
  type        = string
  description = <<-EOT
    "This is the prefix for the key vault resource groups for this repo. Used to determine the key vault to be used.
    e.g. `rg-sparq-terraform_test-centralus`. 
    Don't use a dash at the end like in the backend config. You can interpolate without it but syntax highlighting is borked if so e.g. `$${var.workspace_prefix}$${env}`."
  EOT
  default     = "rg-sparq-infrastructure"
}
variable "key_vault_prefix" {
  type        = string
  description = <<-EOT
    "This is the prefix for the key vaults for this repo. Used to determine the key vault from which to pull secrets for terraform cloud variables.
    e.g. `kv-sparq-terraform_test-centralus`. 
    Don't use a dash at the end like in the backend config. You can interpolate without it but syntax highlighting is borked if so e.g. `$${var.workspace_prefix}$${env}`."
  EOT
  default     = "kv-sparq-infrastruct"
}
# variable "tag_names" {
#   type        = list(string)
#   description = "A list of tag names to be applied to the workspace. These are useful for identifying/filtering resources in Terraform Cloud."
# }


variable "workspace_environments" {
  description = "These are the environments to which the infrastructure in this repo will be deployed."
  type = object({

    stg = object({
      enabled                 = bool
      location                = optional(string)
      application_name        = optional(string)
      debug_outputs           = optional(bool)
      debug_sensitive_outputs = optional(bool)
      trigger_prefixes        = optional(list(string))
      tfc_ssh_key_name        = string
      allow_destroy_plan      = optional(bool)
      queue_all_runs          = optional(bool)
      execution_mode          = optional(string)
      working_directory       = optional(string)
      speculative_enabled     = optional(bool)
      # Tags must only contain letters, numbers or colons
      tag_names = optional(list(string))
      vcs_repo = object({
        branch             = optional(string)
        identifier         = optional(string)
        ingress_submodules = optional(bool)
      })
      variables = optional(list(
        object({
          key         = string
          value       = string
          description = string
          type        = string
          sensitive   = bool
      })))
      environment_variables = optional(list(
        object({
          key         = string
          value       = string
          description = string
          type        = string
          sensitive   = bool
      })))
      depends_on = optional(any)
    })

    dev = object({
      enabled                 = bool
      location                = optional(string)
      application_name        = optional(string)
      debug_outputs           = optional(bool)
      debug_sensitive_outputs = optional(bool)
      trigger_prefixes        = optional(list(string))
      tfc_ssh_key_name        = string
      allow_destroy_plan      = optional(bool)
      queue_all_runs          = optional(bool)
      execution_mode          = optional(string)
      working_directory       = optional(string)
      speculative_enabled     = optional(bool)
      # Tags must only contain letters, numbers or colons
      tag_names = optional(list(string))
      vcs_repo = object({
        branch             = optional(string)
        identifier         = optional(string)
        ingress_submodules = optional(bool)
      })
      variables = optional(list(
        object({
          key         = string
          value       = string
          description = string
          type        = string
          sensitive   = bool
      })))
      environment_variables = optional(list(
        object({
          key         = string
          value       = string
          description = string
          type        = string
          sensitive   = bool
      })))
      depends_on = optional(any)
    })

    prd = object({
      enabled                 = bool
      location                = optional(string)
      application_name        = optional(string)
      debug_outputs           = optional(bool)
      debug_sensitive_outputs = optional(bool)
      trigger_prefixes        = optional(list(string))
      tfc_ssh_key_name        = string
      allow_destroy_plan      = optional(bool)
      queue_all_runs          = optional(bool)
      execution_mode          = optional(string)
      working_directory       = optional(string)
      speculative_enabled     = optional(bool)
      # Tags must only contain letters, numbers or colons
      tag_names = optional(list(string))
      vcs_repo = object({
        branch             = optional(string)
        identifier         = optional(string)
        ingress_submodules = optional(bool)
      })
      variables = optional(list(
        object({
          key         = string
          value       = string
          description = string
          type        = string
          sensitive   = bool
      })))
      environment_variables = optional(list(
        object({
          key         = string
          value       = string
          description = string
          type        = string
          sensitive   = bool
      })))
      depends_on = optional(any)
    })

  })
  default = {
    stg = {
      enabled               = true
      tfc_ssh_key_name      = null
      tag_names             = null
      variables             = null
      environment_variables = null
      vcs_repo              = null
      # vcs_repo = {
      #   identifier         = null
      #   branch             = null
      #   ingress_submodules = false
      # }
    }
    dev = {
      enabled               = true
      tfc_ssh_key_name      = null
      tag_names             = null
      variables             = null
      environment_variables = null
      vcs_repo              = null
      # vcs_repo = {
      #   identifier         = null
      #   branch             = null
      #   ingress_submodules = false
      # }
    }
    prd = {
      enabled               = true
      tfc_ssh_key_name      = null
      tag_names             = null
      variables             = null
      environment_variables = null
      vcs_repo              = null
      # vcs_repo = {
      #   identifier         = null
      #   branch             = null
      #   ingress_submodules = false
      # }
    }
  }
}

# TODO expand this description to cover all of these nested variables
# variable "vcs_repo" {
#   type = object({
#     identifier = string

#   })
#   description = <<-EOT
#     "The VCS repo for this workspace."
#     vcs_repo {
#       identifier = A reference to your VCS repository in the format <organization>/<repository> 
#                    where <organization> and <repository> refer to the organization and repository in your VCS provider.
#       branch = The repository branch that Terraform will execute from.
#       ingress_submodules = Indicates whether submodules should be fetched when cloning the VCS repository.
#       oauth_token_id = OAuth token ID of the configured VCS connection.
#     }
#   EOT
# }