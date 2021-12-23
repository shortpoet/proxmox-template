###################################
# Azure Service Principal Outputs #
###################################
output "service_principal_display_name" {
  description = "The display name of service principal. Can be used to assign roles to user."
  value       = module.module_service_principal.service_principal_display_name
}
output "service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.module_service_principal.service_principal_object_id
}
output "service_principal_application_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = module.module_service_principal.service_principal_application_id
}
output "client_id" {
  description = "The application id of AzureAD application created."
  value       = module.module_service_principal.client_id
}
output "client_secret" {
  description = "Password for service principal."
  value       = module.module_service_principal.client_secret
  sensitive   = true
}
output "service_principal_password" {
  description = "Password for service principal."
  value       = module.module_service_principal.service_principal_password
  sensitive   = true
}