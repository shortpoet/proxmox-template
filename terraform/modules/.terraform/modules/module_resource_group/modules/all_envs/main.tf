module "resource_group_stg" {
  source                  = "./resource_group/stg"
  enabled_for_deployment  = var.resource_group_environments["stg"].enabled
  resource_group_name     = var.resource_group_environments["stg"].resource_group_name
  resource_group_location = var.resource_group_environments["stg"].resource_group_location
  resource_group_tags     = var.resource_group_environments["stg"].resource_group_tags
  providers = {
    azurerm.stg = azurerm.stg
  }

  debug_outputs = var.debug_outputs
}
module "resource_group_dev" {
  source                  = "./resource_group/dev"
  resource_group_name     = var.resource_group_environments["dev"].resource_group_name
  resource_group_location = var.resource_group_environments["dev"].resource_group_location
  enabled_for_deployment  = var.resource_group_environments["dev"].enabled

  resource_group_tags = var.resource_group_environments["dev"].resource_group_tags
  providers = {
    azurerm.dev = azurerm.dev
  }

  debug_outputs = var.debug_outputs
}
module "resource_group_prd" {
  source                  = "./resource_group/prd"
  resource_group_name     = var.resource_group_environments["prd"].resource_group_name
  resource_group_location = var.resource_group_environments["prd"].resource_group_location
  enabled_for_deployment  = var.resource_group_environments["prd"].enabled

  resource_group_tags = var.resource_group_environments["prd"].resource_group_tags
  providers = {
    azurerm.prd = azurerm.prd
  }

  debug_outputs = var.debug_outputs
}
