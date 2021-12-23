###########
# Outputs #
###########

#################
# Debug Outputs #
#################

#######################
# Terraform Workspace #
#######################

output "terraform_variables" {
  value = var.debug_outputs ? tfe_variable.terraform_variables[*] : null
}
output "environment_variables" {
  value = var.debug_outputs ? tfe_variable.environment_variables[*] : null
}
