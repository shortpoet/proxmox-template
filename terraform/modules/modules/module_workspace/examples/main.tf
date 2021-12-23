####################
# Workspace Module #
####################
locals {
  workspace_environments_changes = { for env, values in var.workspace_environments : env => {
    application_name = var.application_name
    location         = var.location
    # this adds service principal env vars from key vault
    default_secrets_enabled = true
    environment_variables = tolist([
      {
        key         = "ARM_SUBSCRIPTION_ID"
        value       = lookup(var.azure_subscription_id_map, env)
        description = "This is to verify that the merge takes the second arguement."
        sensitive   = true
        type        = "PLAIN_TEXT"
      },
      {
        key         = "ARM_CLIENT_ID"
        value       = "Service-Principal-Sparq-Infrastructure-${title(env)}-AppId"
        description = "This is the azure subscription (env) service principal id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
        sensitive   = true
        type        = "KEY_VAULT"
      },
      {
        key         = "ARM_CLIENT_SECRET"
        value       = "Service-Principal-Sparq-Infrastructure-${title(env)}-Password"
        description = "This is the azure subscription (env) service principal password to use -  an environment variable for terraform config e.g. `TF_VAR_`."
        sensitive   = true
        type        = "KEY_VAULT"
      }
    ])
    }
  }
  workspace_environments = { for env, values in var.workspace_environments : env => merge(values, local.workspace_environments_changes["${env}"]) }
}

module "module_workspace" {
  source                          = "../modules"
  workspace_prefix                = var.application_name
  key_vault_resource_group_prefix = "rg-sparq-infrastructure-${var.location}"
  key_vault_prefix                = "kv-sparq-infrastruct"

  oauth_token_id            = var.oauth_token_id
  azure_subscription_id_stg = var.azure_subscription_id_stg
  azure_subscription_id_dev = var.azure_subscription_id_dev
  azure_subscription_id_prd = var.azure_subscription_id_prd
  tfc_ssh_key_name          = var.tfc_ssh_key_name
  workspace_environments    = local.workspace_environments
  terraform_version         = "1.0.11"
}
