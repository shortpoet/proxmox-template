################################
# Azure Resource Group Outputs #
################################
output "id" {
  value       = module.module_resource_group.id
  description = "The ID of the Resource Group."
}

output "name" {
  value       = module.module_resource_group.name
  description = "The Name of the Resource Group."
}

output "location" {
  value       = module.module_resource_group.location
  description = "The Name of the Resource Group."
}

#################
# Debug Outputs #
#################
output "tags" {
  value       = var.debug_outputs ? module.module_resource_group.tags : null
  description = "The Name of the Resource Group."
}

