# Create the Azure Service Principal

data "azuread_client_config" "ad_client_config" {}

resource "random_uuid" "application_scope_id" {
  count = var.enabled_for_deployment ? 1 : 0
}
resource "azuread_application" "ad_application" {
  count            = var.enabled_for_deployment ? 1 : 0
  display_name     = var.service_principal_name
  # new format https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-breaking-changes#appid-uri-in-single-tenant-applications-will-require-use-of-default-scheme-or-verified-domains
  identifier_uris  = ["api://${data.azuread_client_config.ad_client_config.tenant_id}/${var.service_principal_name}"]
  owners           = [data.azuread_client_config.ad_client_config.object_id]
  sign_in_audience = var.sign_in_audience
  api {
    oauth2_permission_scope {
      admin_consent_description =  "Allow the application to access ${var.service_principal_name} on behalf of the signed-in user."
      admin_consent_display_name = "Access ${var.service_principal_name}"
      enabled = true
      id = random_uuid.application_scope_id[count.index].result
      type = "User"
      user_consent_description = "Allow the application to access ${var.service_principal_name} on your behalf."
      user_consent_display_name = "Access ${var.service_principal_name}"
      value = "user_impersonation"
    }
  }
  tags  = var.tags
}
resource "azuread_application_password" "ad_app_pass" {
  count             = var.enabled_for_deployment ? 1 : 0
  application_object_id = azuread_application.ad_application[count.index].object_id
  display_name = "rbac"
}
resource "azuread_service_principal" "ad_sp" {
  count             = var.enabled_for_deployment ? 1 : 0
  application_id    = azuread_application.ad_application[count.index].application_id
  owners            = [data.azuread_client_config.ad_client_config.object_id]
  alternative_names = var.alternative_names
  description       = var.description
  tags  = var.tags
}
resource "time_rotating" "time_rotate" {
  count            = var.enabled_for_deployment ? 1 : 0
  rotation_rfc3339 = var.password_end_date
  rotation_years   = var.password_rotation_in_years
  rotation_days    = var.password_rotation_in_days
  triggers = {
    end_date = var.password_end_date
    years    = var.password_rotation_in_years
    days     = var.password_rotation_in_days
  }
}

resource "azuread_service_principal_password" "ad_sp_pass" {
  count                = var.enabled_for_deployment == true ? 1 : 0
  service_principal_id = azuread_service_principal.ad_sp[count.index].object_id
  rotate_when_changed = {
    rotation = time_rotating.time_rotate[count.index].id
  }
}

resource "azuread_service_principal_certificate" "ad_sp_cert" {
  count                = var.enabled_for_deployment == true && var.enable_service_principal_certificate == true ? 1 : 0
  service_principal_id = azuread_service_principal.ad_sp[count.index].id
  type                 = var.certificate_type
  encoding             = var.certificate_encoding
  key_id               = var.key_id
  value                = file(var.certificate_path)
  end_date             = time_rotating.time_rotate[count.index].id
}

# Create the role assignments

resource "azurerm_role_assignment" "role_assign" {
  count                = var.enabled_for_deployment == true ? length(var.assignments) : 0
  name                 = var.azure_role_name
  description          = var.azure_role_description
  scope                = var.assignments[count.index].scope
  role_definition_name = var.assignments[count.index].role_definition_name
  principal_id         = azuread_service_principal.ad_sp[count.index].object_id
  provider             = azurerm.dev
}