# Configure name/label & tags
module "module_label_service_principal" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  enabled             = var.enabled_for_deployment
  namespace           = "sp"
  project             = "sparq"
  name                = var.application_name
  region              = var.service_principal_location
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^-a-zA-Z0-9_]/"
  # service principal doesn't have map for tags, rather set of string
  tags = {}
}

# Create the Azure Service Principal
data "azuread_client_config" "ad_client_config" {}
data "azurerm_subscription" "sub_primary" {
}
resource "random_uuid" "application_scope_id" {
  count = var.enabled_for_deployment ? 1 : 0
}
locals {
  tags = setunion(var.sp_tags, ["${var.env}"])
}
resource "azuread_application" "ad_application" {
  count        = var.enabled_for_deployment ? 1 : 0
  display_name = module.module_label_service_principal.id
  # new format https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-breaking-changes#appid-uri-in-single-tenant-applications-will-require-use-of-default-scheme-or-verified-domains
  identifier_uris  = ["api://${data.azuread_client_config.ad_client_config.tenant_id}/${module.module_label_service_principal.id}"]
  owners           = [data.azuread_client_config.ad_client_config.object_id]
  sign_in_audience = var.sign_in_audience
  api {
    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ${module.module_label_service_principal.id} on behalf of the signed-in user."
      admin_consent_display_name = "Access ${module.module_label_service_principal.id}"
      enabled                    = true
      id                         = random_uuid.application_scope_id[count.index].result
      type                       = "User"
      user_consent_description   = "Allow the application to access ${module.module_label_service_principal.id} on your behalf."
      user_consent_display_name  = "Access ${module.module_label_service_principal.id}"
      value                      = "user_impersonation"
    }
  }
  tags = local.tags
}
resource "azuread_application_password" "ad_app_pass" {
  count                 = var.enabled_for_deployment ? 1 : 0
  application_object_id = azuread_application.ad_application[count.index].object_id
  display_name          = "rbac"
}
resource "azuread_service_principal" "ad_sp" {
  count             = var.enabled_for_deployment ? 1 : 0
  application_id    = azuread_application.ad_application[count.index].application_id
  owners            = [data.azuread_client_config.ad_client_config.object_id]
  alternative_names = var.alternative_names
  description       = var.description
  tags              = local.tags
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

# Create custom role
# this is broken on the Azure REST API side
# can create a role but it inconsistently times out
# https://discuss.hashicorp.com/t/data-source-for-custom-role-definition-using-azurerm-role-definition-is-not-working/25835
# https://github.com/hashicorp/terraform-provider-azurerm/issues/12236
# https://github.com/Azure/azure-rest-api-specs/issues?q=is%3Aissue+is%3Aopen+create+role
resource "azurerm_role_definition" "create_role_definition" {
  for_each    = var.enabled_for_deployment == true ? { 
    for role in var.custom_roles: role.name => role 
  } : {}
  name        = each.value.name
  scope       = each.value.assignable_scopes[0]
  description = each.value.description

  permissions {
    actions          = each.value.permissions.actions
    not_actions      = each.value.permissions.not_actions
    data_actions     = each.value.permissions.data_actions
    not_data_actions = each.value.permissions.not_data_actions
  }

  assignable_scopes = each.value.assignable_scopes
}

# resource "null_resource" "verify_role_destroy" {
#   count = length(var.custom_roles_json)
#   triggers = {
#     "role_definition_name"  = "${var.custom_roles_json[count.index].Name}"
#     "env" = "${var.env}"
#   }
#   provisioner "local-exec" {
#     when    = destroy
#     command = "pwsh -NoProfile -Command ${path.module}/Get-RoleAssignments.ps1 -Environment '${self.triggers.env}' -RoleName '${self.triggers.role_definition_name}' -HasRoleAssignment $False"
#   }
#   # depends_on = [
#   #   null_resource.create_role_definition
#   # ]
#   lifecycle {
#     create_before_destroy = true
#   }
  
# }

# resource "null_resource" "create_role_definition" {
#   # for_each    = var.enabled_for_deployment == true ? { 
#   #   for role in var.custom_roles: role.name => role 
#   # } : {}
#   count = length(var.custom_roles_json)
#   triggers = {
#     "role_definition_name"  = "${var.custom_roles_json[count.index].Name}"
#     "role_definition_scope" = "${var.custom_roles_json[count.index].AssignableScopes[0]}"
#     "description"           = "${var.custom_roles_json[count.index].Description}"
#     "actions"               = try(join(",", var.custom_roles_json[count.index].Actions), "")
#     "not_actions"           = try(join(",", var.custom_roles_json[count.index].NotActions), "")
#     "data_actions"          = try(join(",", var.custom_roles_json[count.index].DataActions), "")
#     "not_data_actions"      = try(join(",", var.custom_roles_json[count.index].NotDataActions), "")
#     "env" = "${var.env}"
#   }
#   provisioner "local-exec" {
#     command = <<EOF
#     az account set -s "sparq-${var.env}"
#     az role definition create --role-definition '${jsonencode(var.custom_roles_json[count.index])}'
#     EOF
#     interpreter = [
#       "C:/Program Files/Git/bin/bash", "-c"
#     ]
#   }
#   provisioner "local-exec" {
#     when    = destroy
#     command = <<EOF
#     az account set -s "sparq-${self.triggers.env}"
#     az role definition delete --name '${self.triggers.role_definition_name}'
#     EOF
#     interpreter = [
#       "C:/Program Files/Git/bin/bash", "-c"
#     ]
#   }
#   # lifecycle {
#   #   create_before_destroy = true
#   # }
# }

# resource "null_resource" "verify_role_creation" {
#   count = length(var.custom_roles_json)
#   triggers = {
#     "role_definition_name" = var.custom_roles_json[count.index].Name
#   }

#   provisioner "local-exec" {
#     command = "pwsh -NoProfile -Command ${path.module}/Get-RoleAssignments.ps1 -Environment '${var.env}' -RoleName '${self.triggers.role_definition_name}' -HasRoleAssignment $True"
#   }
#   depends_on = [
#     null_resource.create_role_definition
#   ]
#   lifecycle {
#     create_before_destroy = true
#   }
  
# }

# Create the role assignments

resource "azurerm_role_assignment" "builtin_role_assign" {
  count                = var.enabled_for_deployment == true ? length(var.assignments) : 0
  name                 = var.azure_role_name
  description          = var.azure_role_description
  scope                = var.assignments[count.index].scope
  role_definition_name = var.assignments[count.index].role_definition_name
  principal_id         = azuread_service_principal.ad_sp.*.object_id[0]
}
resource "azurerm_role_assignment" "custom_role_assign" {
  count              = var.enabled_for_deployment == true ? length(var.custom_assignments) : 0
  name               = var.azure_role_name
  description        = var.custom_assignments[count.index].description
  scope              = var.custom_assignments[count.index].scope
  role_definition_id = azurerm_role_definition.create_role_definition[var.custom_assignments[count.index].role_definition_name].role_definition_resource_id
  principal_id       = azuread_service_principal.ad_sp.*.object_id[0]
  depends_on = [
    azurerm_role_definition.create_role_definition
    # null_resource.verify_role_creation,
    # null_resource.create_role_definition
  ]
}