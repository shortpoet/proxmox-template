#################################
# Azure Resource Group  Outputs #
#################################
output "id" {
  value       = azurerm_resource_group.main[*].id
  description = "The ID of the Resource Group."
}

output "name" {
  value       = azurerm_resource_group.main[*].name
  description = "The Name of the Resource Group."
}

output "location" {
  value       = azurerm_resource_group.main[*].location
  description = "The Name of the Resource Group."
}

#################
# Debug Outputs #
#################
output "tags" {
  value       = var.debug_outputs ? azurerm_resource_group.main[*].tags : null
  description = "The Name of the Resource Group."
}

