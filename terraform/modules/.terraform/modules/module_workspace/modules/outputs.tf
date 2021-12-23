###########
# Outputs #
###########

#################
# Debug Outputs #
#################

##########################
# Terraform Organization #
##########################
output "tfe_orgs" {
  value = var.debug_outputs ? {
    names = data.tfe_organizations.tfe_orgs.names
    ids   = data.tfe_organizations.tfe_orgs.ids
  } : null
}
output "tfe_orgs_full" {
  value = var.debug_outputs ? data.tfe_organizations.tfe_orgs : null
}
output "tfe_org" {
  value = var.debug_outputs ? data.tfe_organization.sparq_org : null
}
output "tfe_ssh_key" {
  value = var.debug_outputs ? data.tfe_ssh_key.this_ssh_key : null
}
#######################
# Terraform Workspace #
#######################
output "tfc_workspace_name_env" {
  value = var.debug_outputs ? var.TFC_WORKSPACE_NAME : null
}
output "tfc_workspace" {
  value = var.debug_outputs ? tfe_workspace.this_workspace[*] : null
}
# output "tfc_workspace_vcs_repo" {
#   value = var.debug_outputs && tfe_workspace.this_workspace[*].vcs_repo != null ? tfe_workspace.this_workspace[*].vcs_repo : null
# }
output "tfc_workspace_vcs_repo" {
  value = var.debug_outputs ? try(tfe_workspace.this_workspace[*].vcs_repo, null) : null
}
# output "workspace" {
#   value = var.debug_outputs ? local.my_workspace_env : null
# }
output "workspaces" {
  value = var.debug_outputs ? local.workspaces : null
}

output "variables_stg" {
  value     = var.debug_sensitive_outputs ? module.variables_stg : null
  sensitive = true
}
output "variables_dev" {
  value     = var.debug_sensitive_outputs ? module.variables_dev : null
  sensitive = true
}
output "variables_prd" {
  value     = var.debug_sensitive_outputs ? module.variables_prd : null
  sensitive = true
}
