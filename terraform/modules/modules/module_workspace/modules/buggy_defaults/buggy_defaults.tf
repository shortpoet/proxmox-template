##########################
# Terraform Organization #
##########################

data "tfe_organizations" "tfe_orgs" {
}
data "tfe_organization" "sparq_org" {
  name = var.tfc_organization
}
data "tfe_ssh_key" "this_ssh_key" {
  name         = var.tfc_ssh_key_name
  organization = var.tfc_organization
}

#######################
# Terraform Workspace #
#######################
locals {
  # https://github.com/hashicorp/terraform/issues/22802#issuecomment-622447569
  # If your backend is not Terraform Cloud, the value is ${terraform.workspace} 
  # otherwise the value retrieved is that of the TFC_WORKSPACE_NAME with trimprefix
  # my_workspace_env = var.TFC_WORKSPACE_NAME != "" ? trimprefix("${var.TFC_WORKSPACE_NAME}", "${var.tfc_workspace_name}") : "${terraform.workspace}"
  # workspaces       = toset([for env, values in var.workspace_environments : "${var.workspace_prefix}-${env}"])
  workspaces = { for env, values in var.workspace_environments : "${var.workspace_prefix}-${env}" => env }
  default = {
    # application_name = ""
    location      = "centralus"
    debug_outputs = false
    environment_variables = tolist([
      {
        key         = "azure_subscription_id"
        value       = "Sparq-ARM-Subscription-Id"
        description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
        type        = "KEY_VAULT"
        sensitive   = true
      }
    ])
    execution_mode      = "local"
    queue_all_runs      = true
    speculative_enabled = true
    tag_names           = "" # actually [""]
    trigger_prefixes    = "" # actually [""]
    variables = tolist([
      {
        key         = "environment",
        value       = "stg",
        description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace.",
        type        = "PLAIN_TEXT",
        sensitive   = false
      },
      {
        key         = "location",
        value       = "centralus",
        description = "This is the azure location to use - an environment variable for terraform workspace.",
        type        = "PLAIN_TEXT",
        sensitive   = false
      }
    ])
    vcs_repo = {}
    # vcs_repo = {
    #   identifier         = null
    #   branch             = null
    #   ingress_submodules = false
    # }
    working_directory = ".iac"
  }
  # workspace_environments = { for env, values in var.workspace_environments : env => merge(local.default, values) }
  # workspace_environments = { for env, values in var.workspace_environments : env => merge({
  #   location      = "centralus"
  #   debug_outputs = false
  #   environment_variables = [
  #     {
  #       key         = "azure_subscription_id"
  #       value       = "Sparq-ARM-Subscription-Id"
  #       description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
  #       sensitive   = true
  #       type        = "KEY_VAULT"
  #     }
  #   ]
  #   execution_mode      = "local"
  #   queue_all_runs      = true
  #   speculative_enabled = true
  #   tag_names           = ["${env}"]
  #   trigger_prefixes    = null
  #   variables = [
  #     {
  #       key         = "environment",
  #       value       = "${env}",
  #       description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace.",
  #       type        = "PLAIN_TEXT",
  #       sensitive   = false
  #     },
  #     {
  #       key         = "location",
  #       value       = "centralus",
  #       description = "This is the azure location to use - an environment variable for terraform workspace.",
  #       type        = "PLAIN_TEXT",
  #       sensitive   = false
  #     }
  #   ]
  #   vcs_repo = {
  #     identifier         = null
  #     branch             = null
  #     ingress_submodules = false
  #   }
  #   working_directory = ".iac"
  # }, values) }

  work_env = { for env, values in var.workspace_environments : env => local.default }
  workspace_environments = { for env, values in var.workspace_environments : env => defaults(var.env, {
    # application_name = ""
    location      = "centralus"
    debug_outputs = false
    environment_variables = tolist([
      {
        key         = "azure_subscription_id"
        value       = "Sparq-ARM-Subscription-Id"
        description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
        type        = "KEY_VAULT"
        sensitive   = true
      }
    ])
    execution_mode      = "local"
    queue_all_runs      = true
    speculative_enabled = true
    tag_names           = "" # actually [""]
    trigger_prefixes    = "" # actually [""]
    variables = tolist([
      {
        key         = "environment",
        value       = "stg",
        description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace.",
        type        = "PLAIN_TEXT",
        sensitive   = false
      },
      {
        key         = "location",
        value       = "centralus",
        description = "This is the azure location to use - an environment variable for terraform workspace.",
        type        = "PLAIN_TEXT",
        sensitive   = false
      }
    ])
    vcs_repo = {}
    # vcs_repo = {
    #   identifier         = null
    #   branch             = null
    #   ingress_submodules = false
    # }
    working_directory = ".iac"
  }) }
  # workspace_environments = defaults(var.workspace_environments, local.work_env)
  # workspace_environments = { for env, values in var.workspace_environments : env => defaults(values, {
  #   location      = "centralus"
  #   debug_outputs = false
  #   environment_variables = [
  #     {
  #       key         = "azure_subscription_id"
  #       value       = "Sparq-ARM-Subscription-Id"
  #       description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
  #       sensitive   = true
  #       type        = "KEY_VAULT"
  #     }
  #   ]
  #   execution_mode      = "local"
  #   queue_all_runs      = true
  #   speculative_enabled = true
  #   tag_names           = []
  #   trigger_prefixes    = null
  #   variables = [
  #     {
  #       key         = "environment",
  #       value       = "stg",
  #       description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace.",
  #       type        = "PLAIN_TEXT",
  #       sensitive   = false
  #     },
  #     {
  #       key         = "location",
  #       value       = "centralus",
  #       description = "This is the azure location to use - an environment variable for terraform workspace.",
  #       type        = "PLAIN_TEXT",
  #       sensitive   = false
  #     }
  #   ]
  #   vcs_repo = {
  #     identifier         = null
  #     branch             = null
  #     ingress_submodules = false
  #   }
  #   working_directory = ".iac"
  # }) }
  # workspace_environments = defaults(var.workspace_environments, {

  # })
}

# data "tfe_workspace" "this_workspace" {
#   name = var.tfc_workspace_name
#   # organization = tfe_organization.sparq.name
#   organization = var.tfc_organization
# }

# output "workspaces" {
#   value = local.workspaces
# }

output "work_env" {
  value = local.work_env
}
output "workspace_env" {
  value = local.workspace_environments
}

# resource "tfe_workspace" "this_workspace" {
#   # The Name of the workspace to create in Terraform Cloud
#   for_each           = { for env, values in local.workspace_environments : env => values if values.enabled }
#   name               = "${var.workspace_prefix}-${each.key}"
#   organization       = data.tfe_organization.sparq_org.name
#   trigger_prefixes   = each.value.trigger_prefixes
#   allow_destroy_plan = false
#   queue_all_runs     = each.value.queue_all_runs
#   execution_mode     = "remote"
#   # set var.working_directory to null in order to use individual environment settings - both default to .iac
#   working_directory   = var.working_directory == null ? each.value.working_directory : var.working_directory
#   ssh_key_id          = data.tfe_ssh_key.this_ssh_key.id
#   speculative_enabled = each.value.speculative_enabled
#   dynamic "vcs_repo" {
#     for_each = each.value.vcs_repo == null ? [] : [each.value.vcs_repo]
#     content {
#       branch             = vcs_repo.value.branch
#       identifier         = vcs_repo.value.identifier
#       ingress_submodules = vcs_repo.value.ingress_submodules
#       oauth_token_id     = var.oauth_token_id
#     }
#   }
#   tag_names         = each.value.tag_names
#   terraform_version = var.terraform_version
# }

# module "variables_stg" {
#   source                = "./tf-cloud-variables"
#   env                   = "stg"
#   resource_group_name   = "${var.resource_group_prefix}-stg"
#   key_vault_name        = "${var.key_vault_prefix}-stg"
#   workspace_id          = try(tfe_workspace.this_workspace["stg"].id, null)
#   terraform_variables   = try(var.workspace_environments["stg"].variables, null)
#   environment_variables = try(var.workspace_environments["stg"].environment_variables, null)
#   providers = {
#     azurerm.stg = azurerm.stg
#     azurerm.dev = azurerm.dev
#     azurerm.prd = azurerm.prd
#   }
#   debug_outputs = var.debug_outputs
# }
# module "variables_dev" {
#   source                = "./tf-cloud-variables"
#   env                   = "dev"
#   resource_group_name   = "${var.resource_group_prefix}-dev"
#   key_vault_name        = "${var.key_vault_prefix}-dev"
#   workspace_id          = try(tfe_workspace.this_workspace["dev"].id, null)
#   terraform_variables   = try(var.workspace_environments["dev"].variables, null)
#   environment_variables = try(var.workspace_environments["dev"].environment_variables, null)
#   providers = {
#     azurerm.stg = azurerm.stg
#     azurerm.dev = azurerm.dev
#     azurerm.prd = azurerm.prd
#   }
#   debug_outputs = var.debug_sensitive_outputs
# }
# module "variables_prd" {
#   source                = "./tf-cloud-variables"
#   env                   = "prd"
#   resource_group_name   = "${var.resource_group_prefix}-prd"
#   key_vault_name        = "${var.key_vault_prefix}-prd"
#   workspace_id          = try(tfe_workspace.this_workspace["prd"].id, null)
#   terraform_variables   = try(var.workspace_environments["prd"].variables, null)
#   environment_variables = try(var.workspace_environments["prd"].environment_variables, null)
#   providers = {
#     azurerm.stg = azurerm.stg
#     azurerm.dev = azurerm.dev
#     azurerm.prd = azurerm.prd
#   }
#   debug_outputs = var.debug_sensitive_outputs
# }

