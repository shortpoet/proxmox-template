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
  source                   = "../../../modules"
  env                      = var.env
  storage_application_name = var.storage_application_name
  resource_group_name      = module.module_resource_group.name[0]
  create_storage_account   = true
  tags                     = var.tags
  additional_st_tags       = var.additional_st_tags

  # sas token
  generate_sas_for_storage_account   = var.generate_sas_for_storage_account
  generate_sas_for_storage_container = var.generate_sas_for_storage_container

  # time rotating
  start            = var.start
  rotation_days    = var.rotation_days
  rotation_hours   = var.rotation_hours
  rotation_minutes = var.rotation_minutes
  rotation_months  = var.rotation_months
  rotation_years   = var.rotation_years
  rotation_margin  = var.rotation_margin

  # permissions
  write = var.write

  depends_on = [
    module.module_resource_group
  ]
}
