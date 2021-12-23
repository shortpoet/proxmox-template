module "module_resource_group" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_resource_group/azure//modules"
  version = "0.1.0"
  ############
  enabled_for_deployment  = var.enabled_for_deployment
  application_name        = var.rg_application_name
  resource_group_location = var.resource_group_location
  env                     = var.env
  tags                    = var.tags
  additional_rg_tags      = var.additional_rg_tags
}

module "module_storage_account" {
  source                   = "../../modules"
  env                      = var.env
  storage_application_name = var.storage_application_name
  resource_group_name      = module.module_resource_group.name[0]
  create_storage_account   = true
  tags                     = var.tags
  additional_st_tags       = var.additional_st_tags

  # containers
  containers_list                   = var.containers_list
  additional_stct_tags              = var.additional_stct_tags
  enable_advanced_threat_protection = var.enable_advanced_threat_protection

  depends_on = [
    module.module_resource_group
  ]
}
