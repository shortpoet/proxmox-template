locals {
  default = {
    enabled       = true
    debug_outputs = false
    # azuread_application
    sign_in_audience = "AzureADMyOrg"
    # azuread_service_principal
    alternative_names = []
    description       = null
    # time_rotating
    password_end_date          = null
    password_rotation_in_years = 1
    password_rotation_in_days  = null
    # azuread_service_principal_password
    enable_service_principal_certificate = false
    # azuread_service_principal_certificate
    certificate_type     = "AsymmetricX509Cert"
    certificate_encoding = "pem"
    key_id               = null
    certificate_path     = ""
    # azurerm_role_assignment
    azure_role_name        = null
    azure_role_description = null
    assignments            = []
  }
  service_principal_environments = { for env, values in var.service_principal_environments : env => {
    enabled                              = values.enabled == null ? local.default.enabled : values.enabled
    debug_outputs                        = values.debug_outputs == null ? local.default.debug_outputs : values.debug_outputs
    service_principal_name               = values.service_principal_name
    sign_in_audience                     = values.sign_in_audience == null ? local.default.sign_in_audience : values.sign_in_audience
    alternative_names                    = values.alternative_names == null ? local.default.alternative_names : values.alternative_names
    description                          = values.description == null ? local.default.description : values.description
    password_end_date                    = values.password_end_date == null ? local.default.password_end_date : values.password_end_date
    password_rotation_in_years           = values.password_rotation_in_years == null ? local.default.password_rotation_in_years : values.password_rotation_in_years
    password_rotation_in_days            = values.password_rotation_in_days == null ? local.default.password_rotation_in_days : values.password_rotation_in_days
    enable_service_principal_certificate = values.enable_service_principal_certificate == null ? local.default.enable_service_principal_certificate : values.enable_service_principal_certificate
    certificate_type                     = values.certificate_type == null ? local.default.certificate_type : values.certificate_type
    certificate_encoding                 = values.certificate_encoding == null ? local.default.certificate_encoding : values.certificate_encoding
    key_id                               = values.key_id == null ? local.default.key_id : values.key_id
    certificate_path                     = values.certificate_path == null ? local.default.certificate_path : values.certificate_path
    azure_role_name                      = values.azure_role_name == null ? local.default.azure_role_name : values.azure_role_name
    azure_role_description               = values.azure_role_description == null ? local.default.azure_role_description : values.azure_role_description
    assignments                          = values.assignments == null ? local.default.assignments : values.assignments
    tags                                 = values.tags
    }
  }
}

module "service_principal_stg" {
  source                 = "./service_principal/stg"
  enabled_for_deployment = local.service_principal_environments["stg"].enabled
  # azuread_application
  service_principal_name = local.service_principal_environments["stg"].service_principal_name
  sign_in_audience       = local.service_principal_environments["stg"].sign_in_audience
  # azuread_service_principal
  alternative_names = local.service_principal_environments["stg"].alternative_names
  description       = local.service_principal_environments["stg"].description

  # time_rotating
  password_end_date          = local.service_principal_environments["stg"].password_end_date
  password_rotation_in_years = local.service_principal_environments["stg"].password_rotation_in_years
  password_rotation_in_days  = local.service_principal_environments["stg"].password_rotation_in_days

  # azuread_service_principal_password
  enable_service_principal_certificate = local.service_principal_environments["stg"].enable_service_principal_certificate

  # azuread_service_principal_certificate
  certificate_type     = local.service_principal_environments["stg"].certificate_type
  certificate_encoding = local.service_principal_environments["stg"].certificate_encoding
  key_id               = local.service_principal_environments["stg"].key_id
  certificate_path     = local.service_principal_environments["stg"].certificate_path

  # azurerm_role_assignment
  azure_role_name        = local.service_principal_environments["stg"].azure_role_name
  azure_role_description = local.service_principal_environments["stg"].azure_role_description
  assignments            = local.service_principal_environments["stg"].assignments

  tags = local.service_principal_environments["stg"].tags
  debug_outputs = local.service_principal_environments["stg"].debug_outputs
  providers = {
    azurerm.stg = azurerm.stg
  }
}

module "service_principal_dev" {
  source                 = "./service_principal/dev"
  enabled_for_deployment = local.service_principal_environments["dev"].enabled
  # azuread_application
  service_principal_name = local.service_principal_environments["dev"].service_principal_name
  sign_in_audience       = local.service_principal_environments["dev"].sign_in_audience
  # azuread_service_principal
  alternative_names = local.service_principal_environments["dev"].alternative_names
  description       = local.service_principal_environments["dev"].description

  # time_rotating
  password_end_date          = local.service_principal_environments["dev"].password_end_date
  password_rotation_in_years = local.service_principal_environments["dev"].password_rotation_in_years
  password_rotation_in_days  = local.service_principal_environments["dev"].password_rotation_in_days

  # azuread_service_principal_password
  enable_service_principal_certificate = local.service_principal_environments["dev"].enable_service_principal_certificate

  # azuread_service_principal_certificate
  certificate_type     = local.service_principal_environments["dev"].certificate_type
  certificate_encoding = local.service_principal_environments["dev"].certificate_encoding
  key_id               = local.service_principal_environments["dev"].key_id
  certificate_path     = local.service_principal_environments["dev"].certificate_path

  # azurerm_role_assignment
  azure_role_name        = local.service_principal_environments["dev"].azure_role_name
  azure_role_description = local.service_principal_environments["dev"].azure_role_description
  assignments            = local.service_principal_environments["dev"].assignments

  tags = local.service_principal_environments["dev"].tags
  debug_outputs = local.service_principal_environments["dev"].debug_outputs
  providers = {
    azurerm.dev = azurerm.dev
  }
}

module "service_principal_prd" {
  source                 = "./service_principal/prd"
  enabled_for_deployment = local.service_principal_environments["prd"].enabled
  # azuread_application
  service_principal_name = local.service_principal_environments["prd"].service_principal_name
  sign_in_audience       = local.service_principal_environments["prd"].sign_in_audience
  # azuread_service_principal
  alternative_names = local.service_principal_environments["prd"].alternative_names
  description       = local.service_principal_environments["prd"].description

  # time_rotating
  password_end_date          = local.service_principal_environments["prd"].password_end_date
  password_rotation_in_years = local.service_principal_environments["prd"].password_rotation_in_years
  password_rotation_in_days  = local.service_principal_environments["prd"].password_rotation_in_days

  # azuread_service_principal_password
  enable_service_principal_certificate = local.service_principal_environments["prd"].enable_service_principal_certificate

  # azuread_service_principal_certificate
  certificate_type     = local.service_principal_environments["prd"].certificate_type
  certificate_encoding = local.service_principal_environments["prd"].certificate_encoding
  key_id               = local.service_principal_environments["prd"].key_id
  certificate_path     = local.service_principal_environments["prd"].certificate_path

  # azurerm_role_assignment
  azure_role_name        = local.service_principal_environments["prd"].azure_role_name
  azure_role_description = local.service_principal_environments["prd"].azure_role_description
  assignments            = local.service_principal_environments["prd"].assignments

  tags = local.service_principal_environments["prd"].tags
  debug_outputs = local.service_principal_environments["prd"].debug_outputs
  providers = {
    azurerm.prd = azurerm.prd
  }
}
