####################################################
# Azure Service Principal (per env module) Outputs #
####################################################
output "service_principal_name" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.ad_sp.*.display_name
}

output "service_principal_object_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.ad_sp.*.object_id
}

output "service_principal_application_id" {
  description = "The object id of service principal. Can be used to assign roles to user."
  value       = azuread_service_principal.ad_sp.*.application_id
}

output "client_id" {
  description = "The application id of AzureAD application created."
  value       = azuread_application.ad_application.*.application_id
}

output "client_secret" {
  description = "Password for service principal."
  value       = azuread_application_password.ad_app_pass.*.value
  sensitive   = true
}

output "service_principal_password" {
  description = "Password for service principal."
  value       = azuread_service_principal_password.ad_sp_pass.*.value
  sensitive   = true
}
