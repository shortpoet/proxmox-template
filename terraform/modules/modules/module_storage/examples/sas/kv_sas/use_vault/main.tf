module "module_storage_account" {
  source                   = "../../../../modules"
  env                      = var.env
  storage_application_name = var.storage_application_name
  resource_group_name      = var.key_vault_resource_group_name
  create_storage_account   = true
  tags                     = var.tags
  additional_st_tags       = var.additional_st_tags

  #######
  # SAS #
  #######
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

  ###########
  # KV MGMT #
  ###########
  kv_manage_sas                 = var.kv_manage_sas
  sas_type                      = var.sas_type
  key_vault_name                = var.key_vault_name
  key_vault_resource_group_name = var.key_vault_resource_group_name
  regeneration_validity_period  = var.regeneration_validity_period
  additional_kv_tags            = var.additional_kv_tags
  additional_stmgmt_tags        = var.additional_stmgmt_tags
  additional_stmgmtsasdef_tags  = var.additional_stmgmtsasdef_tags
}
