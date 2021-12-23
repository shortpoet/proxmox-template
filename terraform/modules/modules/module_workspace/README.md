# terraform-hashicorp-module_workspace

- This is a module to create workspaces for different environments based on a repo.

## Sample Vars

```terraform
########################
# Azure Authentication #
########################

# # Azure Tenant Id
# azure_tenant_id = "1fbb64f0-f7c4-44c4-b2fd-f36836517f82"
# # Azure Subscription Id
# azure_subscription_id = "c8686ac2-b880-4bb2-9ffd-d3b660da53ea"
# # Azure Client Id/appId
# azure_client_id = "8bb60a6b-baf4-4a16-b415-e100d053e069"
# # Azure Client Secret/password
# azure_client_secret = "sm_8YEiQjEdMOg.9p0JBkBICxYaZXYoU85"


###################
# Terraform Cloud #
###################

##########################
# Terraform Organization #
##########################

tfc_organization = "sparq"
tfc_ssh_key_name = "id_rsa-fg_sparq_service_terraform@facilisgroup"
oauth_token_id   = "ot-55bYQ8ZGJ5JW8DCR"

#######################
# Terraform Workspace #
#######################

workspace_prefix = "mod-sparq-terraform_test-centralus"
debug_outputs    = true

##########################
# Workspace Environments #
##########################
# possible merge of defaults as in
# https://github.com/hashicorp/terraform/issues/15966

workspace_environments = {

  # defaults = {
  #   location         = "centralus"
  #   application_name = "terraform_test"
  #   debug_outputs    = true
  #   tfc_environment_variables = {
  #     azure_subscription_id = ""
  #   }
  # }

  stg = {
    location         = "centralus"
    application_name = "terraform_test"
    debug_outputs    = false
    environment_variables = [
      {
        key         = "azure_subscription_id"
        value       = "Sparq-ARM-Subscription-Id"
        description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
        sensitive   = true
        type        = "KEY_VAULT"
      }
    ]
    execution_mode      = "local"
    queue_all_runs      = true
    speculative_enabled = true
    tag_names = ["stg"]
    trigger_prefixes    = null
    variables = [
      {
        key         = "environment",
        value       = "stg",
        description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace."
        sensitive   = false
        type        = "PLAIN_TEXT"
      },
      {
        key         = "location",
        value       = "centralus",
        description = "This is the azure location to use - an environment variable for terraform workspace."
        type        = "PLAIN_TEXT",
        sensitive   = false
      }
    ]
    vcs_repo = {
      branch             = ""
      ingress_submodules = false
    }
    working_directory = ".iac"
  }

  dev = {
    location         = "centralus"
    application_name = "terraform_test"
    debug_outputs    = false
    environment_variables = [{
      key         = "azure_subscription_id"
      value       = "Sparq-ARM-Subscription-Id"
      description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
      sensitive   = true
      type        = "KEY_VAULT"
    }]
    execution_mode      = "local"
    queue_all_runs      = true
    speculative_enabled = true
    tag_names = ["dev"]
    trigger_prefixes    = null
    variables = [
      {
        key         = "environment",
        value       = "dev",
        description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace."
        sensitive   = false
        type        = "PLAIN_TEXT"
      },
      {
        key         = "location",
        value       = "centralus",
        description = "This is the azure location to use - an environment variable for terraform workspace."
        type        = "PLAIN_TEXT",
        sensitive   = false
      }
    ]
    vcs_repo = {
      branch             = ""
      ingress_submodules = false
    }
    working_directory = ".iac"
  }

  prd = {
    location         = "centralus"
    application_name = "terraform_test"
    debug_outputs    = false
    environment_variables = [{
      key         = "azure_subscription_id"
      value       = "Sparq-ARM-Subscription-Id"
      description = "This is the azure subscription id to use -  an environment variable for terraform config e.g. `TF_VAR_`."
      sensitive   = true
      type        = "KEY_VAULT"
    }]
    execution_mode      = "local"
    queue_all_runs      = true
    speculative_enabled = true
    tag_names = ["prd"]
    trigger_prefixes    = null
    variables = [
      {
        key         = "environment",
        value       = "prd",
        description = "This is the terraform workspace and azure environment - an environment variable for terraform workspace."
        sensitive   = false
        type        = "PLAIN_TEXT"
      },
      {
        key         = "location",
        value       = "centralus",
        description = "This is the azure location to use - an environment variable for terraform workspace."
        type        = "PLAIN_TEXT",
        sensitive   = false
      }
    ]
    vcs_repo = {
      branch             = ""
      ingress_submodules = false
    }
    working_directory = ".iac"
  }
}
```

## Outputs

- output
  - `terraform output -json variables_prd > outputs/variables_sensitive_prd.json`

- show (verbose resources)
  - `terraform show -json > outputs/initial_run_show.json`
