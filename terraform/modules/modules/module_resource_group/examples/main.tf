module "module_resource_group" {
  source                  = "../modules"
  azure_subscription_id   = var.azure_subscription_id
  enabled_for_deployment  = var.enabled_for_deployment
  application_name        = var.application_name
  resource_group_location = var.resource_group_location
  env                     = var.env
  tags                    = var.tags
  additional_rg_tags      = var.additional_rg_tags
}