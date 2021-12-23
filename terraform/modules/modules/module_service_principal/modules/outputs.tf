###################################
# Azure Service Principal Outputs #
###################################
output "service_principal_display_name" {
  description = "The display name of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.ad_sp.*.display_name
}
output "service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.ad_sp.*.object_id
}
output "service_principal_application_id" {
  description = "The application id of service principal. Can be used to assign roles to user. Should be the same as client_id"
  value       = azuread_service_principal.ad_sp.*.application_id
}
output "client_id" {
  description = "The application id of AzureAD application created. Should be the same as service_principal_application_id."
  value       = azuread_application.ad_application.*.application_id
}
output "client_secret" {
  description = "Password for service principal."
  value       = var.debug_sensitive_outputs ? azuread_application_password.ad_app_pass.*.value : null
  sensitive   = true
}
output "service_principal_password" {
  description = "Password for service principal."
  value       = var.debug_sensitive_outputs ? azuread_service_principal_password.ad_sp_pass.*.value : null
  sensitive   = true
}