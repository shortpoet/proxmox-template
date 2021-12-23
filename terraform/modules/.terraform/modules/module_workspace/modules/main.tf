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

data "azurerm_client_config" "client_config" {}

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
    location                = "centralus"
    enabled                 = true
    debug_outputs           = false
    debug_sensitive_outputs = false
    environment_variables = tolist([
      # this erroneously adds 3x the sub id of the currently selected az sub because running
      # manually for all workspaces
      # {
      #   key         = "ARM_SUBSCRIPTION_ID"
      #   value       = data.azurerm_client_config.client_config.subscription_id
      #   description = "This is the azure subscription id to use - an environment variable for terraform config e.g. `TF_VAR_`."
      #   type        = "PLAIN_TEXT"
      #   sensitive   = true
      # },
      {
        key         = "ARM_TENANT_ID",
        value       = data.azurerm_client_config.client_config.tenant_id,
        description = "This is the azure tenant id to use - an environment variable for terraform config e.g. `TF_VAR_`.",
        type        = "PLAIN_TEXT",
        sensitive   = true
      }
    ])
    # variables = tolist([
    #   {
    #     key         = "env",
    #     value       = "${env}",
    #     description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace.",
    #     type        = "PLAIN_TEXT",
    #     sensitive   = false
    #   },
    #   {
    #     key         = "location",
    #     value       = "${values.location == null ? local.default.location : values.location}",
    #     description = "This is the azure location to use - an environment variable for terraform workspace.",
    #     type        = "PLAIN_TEXT",
    #     sensitive   = false
    #   }
    # ])
    # tag_names = ["${env}", replace("${values.application_name}", "/[^0-9a-zA-Z:]/", "")]
    execution_mode      = "local"
    allow_destroy_plan  = false
    queue_all_runs      = true
    speculative_enabled = true
    trigger_prefixes    = null # [""] causes panic: interface conversion: interface {} is nil, not string
    vcs_repo            = null
    # vcs_repo = {
    #   identifier         = null
    #   branch             = null
    #   ingress_submodules = false
    # }
    working_directory = ".iac"
  }
  # https://discuss.hashicorp.com/t/the-true-and-false-result-expressions-must-have-consistent-types-the-given-expressions-are-object-and-tuple-respectively/4194
  # https://stackoverflow.com/questions/62683298/merge-list-of-objects-in-terraform
  # https://discuss.hashicorp.com/t/merging-complex-objects/2312/4
  mapped_default_environment_variables = { 
    for var in local.default.environment_variables: "${var.key}" => var 
  }
  mapped_environment_variables = { 
    for env, values in var.workspace_environments : env => {
      for var in values.environment_variables: "${var.key}" => 
        var
    }
  }
  merged_environment_variables = { 
    for env, values in var.workspace_environments : env => 
      values(
        merge(
          local.mapped_default_environment_variables,
          lookup(local.mapped_environment_variables, env)
        )
      )
  }
  workspace_environments = { for env, values in var.workspace_environments : env => {
    application_name        = values.application_name
    enabled                 = values.enabled == null ? local.default.enabled : values.enabled
    location                = values.location == null ? local.default.location : values.location
    tfc_ssh_key_name        = values.tfc_ssh_key_name == null ? local.default.tfc_ssh_key_name : values.tfc_ssh_key_name
    debug_outputs           = values.debug_outputs == null ? local.default.debug_outputs : values.debug_outputs
    debug_sensitive_outputs = values.debug_sensitive_outputs == null ? local.default.debug_sensitive_outputs : values.debug_sensitive_outputs

    environment_variables   = lookup(local.merged_environment_variables, env)
    
    # https://stackoverflow.com/questions/56047306/terraform-0-12-nested-for-loops
    # this duplicates the variables due to the nested for loop
    # environment_variables   = values.environment_variables == null ? local.default.environment_variables : flatten([
    #   for var in values.environment_variables: flatten([
    #     for def_var in local.default.environment_variables: [
    #       var.key != def_var.key ? def_var : var
    #     ]
    #   ])
    # ])

    variables = tolist(concat([
      {
        key         = "env",
        value       = "${env}",
        description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace.",
        type        = "PLAIN_TEXT",
        sensitive   = false
      },
      {
        key         = "location",
        value       = "${values.location == null ? local.default.location : values.location}",
        description = "This is the azure location to use - an environment variable for terraform workspace.",
        type        = "PLAIN_TEXT",
        sensitive   = false
      }
    ], values.variables))

    execution_mode          = values.execution_mode == null ? local.default.execution_mode : values.execution_mode
    allow_destroy_plan      = values.allow_destroy_plan == null ? local.default.allow_destroy_plan : values.allow_destroy_plan
    queue_all_runs          = values.queue_all_runs == null ? local.default.queue_all_runs : values.queue_all_runs
    speculative_enabled     = values.speculative_enabled == null ? local.default.speculative_enabled : values.speculative_enabled

    # Tags must only contain letters, numbers or colons
    tag_names        = values.tag_names == null ? ["${env}", replace("${values.application_name}", "/[^0-9a-zA-Z:]/", "")] : concat(["${env}", replace("${values.application_name}", "/[^0-9a-zA-Z:]/", "")], values.tag_names)

    trigger_prefixes = values.trigger_prefixes == null ? local.default.trigger_prefixes : values.trigger_prefixes
    vcs_repo = values.vcs_repo == null ? local.default.vcs_repo : values.vcs_repo
    # vcs_repo = {
    #   identifier         = values.vcs_repo.identifier == null ? local.default.vcs_repo.identifier : values.vcs_repo.identifier
    #   branch             = values.vcs_repo.branch == null ? local.default.vcs_repo.branch : values.vcs_repo.branch
    #   ingress_submodules = values.vcs_repo.ingress_submodules == false ? local.default.vcs_repo.ingress_submodules : values.vcs_repo.ingress_submodules
    # }
    working_directory = values.working_directory == null ? local.default.working_directory : values.working_directory
    depends_on        = values.depends_on
    }
  }
}

# output "workspace_environments" {
#   value = local.workspace_environments
# }

# data "tfe_workspace" "this_workspace" {
#   name = var.tfc_workspace_name
#   # organization = tfe_organization.sparq.name
#   organization = var.tfc_organization
# }

resource "tfe_workspace" "this_workspace" {
  # The Name of the workspace to create in Terraform Cloud
  for_each           = { for env, values in local.workspace_environments : env => values if values.enabled }
  name               = "${var.workspace_prefix}-${each.key}"
  organization       = data.tfe_organization.sparq_org.name
  trigger_prefixes   = each.value.trigger_prefixes
  allow_destroy_plan = each.value.allow_destroy_plan
  queue_all_runs     = each.value.queue_all_runs
  execution_mode     = "remote"
  # set var.working_directory to null in order to use individual environment settings - both default to .iac
  working_directory   = var.working_directory == null ? each.value.working_directory : var.working_directory
  ssh_key_id          = data.tfe_ssh_key.this_ssh_key.id
  speculative_enabled = each.value.speculative_enabled
  dynamic "vcs_repo" {
    for_each = each.value.vcs_repo == null ? [] : [each.value.vcs_repo]
    content {
      branch             = vcs_repo.value.branch
      identifier         = vcs_repo.value.identifier
      ingress_submodules = vcs_repo.value.ingress_submodules
      oauth_token_id     = var.oauth_token_id
    }
  }
  tag_names         = each.value.tag_names
  terraform_version = var.terraform_version
}
module "variables_dev" {
  source                = "./tf-cloud-variables"
  env                   = local.workspace_environments["dev"].enabled ? "dev" : null
  key_vault_resource_group_name   = "${var.key_vault_resource_group_prefix}-dev"
  key_vault_name        = "${var.key_vault_prefix}-dev"
  workspace_id          = local.workspace_environments["dev"].enabled ? tfe_workspace.this_workspace["dev"].id : null
  terraform_variables   = local.workspace_environments["dev"].enabled ? local.workspace_environments["dev"].variables : []
  environment_variables = local.workspace_environments["dev"].enabled ? local.workspace_environments["dev"].environment_variables : []
  providers = {
    azurerm.stg = azurerm.stg
    azurerm.dev = azurerm.dev
    azurerm.prd = azurerm.prd
  }
  debug_outputs                      = local.workspace_environments["dev"].debug_sensitive_outputs
  workspace_variables_dev_depends_on = local.workspace_environments["dev"].depends_on
}
module "variables_stg" {
  source                = "./tf-cloud-variables"
  env                   = local.workspace_environments["stg"].enabled ? "stg" : null
  key_vault_resource_group_name   = "${var.key_vault_resource_group_prefix}-stg"
  key_vault_name        = "${var.key_vault_prefix}-stg"
  workspace_id          = local.workspace_environments["stg"].enabled ? tfe_workspace.this_workspace["stg"].id : null
  terraform_variables   = local.workspace_environments["stg"].enabled ? local.workspace_environments["stg"].variables : []
  environment_variables = local.workspace_environments["stg"].enabled ? local.workspace_environments["stg"].environment_variables : []
  providers = {
    azurerm.stg = azurerm.stg
    azurerm.dev = azurerm.dev
    azurerm.prd = azurerm.prd
  }
  debug_outputs                      = local.workspace_environments["stg"].debug_sensitive_outputs
  workspace_variables_stg_depends_on = local.workspace_environments["stg"].depends_on
}
module "variables_prd" {
  source                = "./tf-cloud-variables"
  env                   = local.workspace_environments["prd"].enabled ? "prd" : null
  key_vault_resource_group_name   = "${var.key_vault_resource_group_prefix}-prd"
  key_vault_name        = "${var.key_vault_prefix}-prd"
  workspace_id          = local.workspace_environments["prd"].enabled ? tfe_workspace.this_workspace["prd"].id : null
  terraform_variables   = local.workspace_environments["prd"].enabled ? local.workspace_environments["prd"].variables : []
  environment_variables = local.workspace_environments["prd"].enabled ? local.workspace_environments["prd"].environment_variables : []
  providers = {
    azurerm.stg = azurerm.stg
    azurerm.dev = azurerm.dev
    azurerm.prd = azurerm.prd
  }
  debug_outputs                      = local.workspace_environments["prd"].debug_sensitive_outputs
  workspace_variables_prd_depends_on = local.workspace_environments["prd"].depends_on
}

