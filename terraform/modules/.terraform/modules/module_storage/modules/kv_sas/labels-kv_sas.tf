module "module_label_key_vault" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  enabled = var.enabled_for_deployment
  # "name" may only contain alphanumeric characters and dashes and must be between 3-24 chars  
  # omit region, possibly project for name length considerations
  # no underscore in kv
  namespace           = "kv"
  project             = "sparq"
  name                = var.key_vault_application_name
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^a-zA-Z0-9-]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "key_vault",
    "Environment"       = var.env
  }, var.additional_kv_tags)

}

module "module_label_key_vault_managed_storage_account" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  enabled             = var.enabled_for_deployment
  namespace           = "stmgmt"
  project             = "sparq"
  name                = var.storage_application_name
  attributes          = ["${var.env}"]
  delimiter           = "8"
  regex_replace_chars = "/[^a-zA-Z0-9]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "key_vault_managed_storage_account",
    "Environment"       = var.env
  }, var.additional_stmgmt_tags)

  context = module.this.context
}
module "module_label_key_vault_managed_storage_account_sas_token_definition" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  enabled             = var.enabled_for_deployment
  namespace           = "stmgmtsasdef"
  project             = "sparq"
  name                = var.storage_application_name
  attributes          = ["${var.env}"]
  delimiter           = "8"
  regex_replace_chars = "/[^a-zA-Z0-9]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "key_vault_managed_storage_account_sas_token_definition",
    "Environment"       = var.env
  }, var.additional_stmgmtsasdef_tags)

  context = module.this.context
}