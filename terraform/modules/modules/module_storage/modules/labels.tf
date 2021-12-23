# The output from `module_label_storage_account` must match the output of an existing sa resource if 
# `create_storage_account` variable is set to `false`
module "module_label_storage_account" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # # for_each = var.storage_account_environments
  # enabled = each.value.enabled
  enabled = var.enabled
  # insert required variables here
  namespace = "st"
  # fix workspace environments to use global application name variable
  name = var.storage_application_name
  # attributes          = ["${each.key}"]
  attributes          = ["${var.env}"]
  delimiter           = "8"
  regex_replace_chars = "/[^a-zA-Z0-9]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "storage_account",
    "Environment"       = var.env
  }, var.additional_st_tags)

  context = module.this.context
}

module "module_label_storage_container" {
  count = length(var.containers_list)
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # for_each = var.containers_list
  # enabled = each.value.enabled
  enabled = var.enabled
  # insert required variables here
  namespace = "stct"
  project   = "sparq"
  # region      = var.location
  # fix workspace environments to use global application name variable
  name = "${var.storage_application_name}-${var.containers_list[count.index].name}"
  # attributes          = ["${each.key}"]
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^a-z0-9-]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "storage_container",
    "Environment"       = var.env
  }, var.additional_stct_tags)

  context = module.this.context
}

module "module_label_storage_file_share" {
  count = length(var.file_shares)
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # for_each = var.file_shares
  # enabled = each.value.enabled
  enabled = var.enabled
  # insert required variables here
  namespace = "stfs"
  project   = "sparq"
  # region      = var.location
  # fix workspace environments to use global application name variable
  name = "${var.storage_application_name}-${var.file_shares[count.index].name}"
  # attributes          = ["${each.key}"]
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^a-z0-9-]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "storage_file_share",
    "Environment"       = var.env
  }, var.additional_stfs_tags)

  context = module.this.context
}

module "module_label_storage_table" {
  count = length(var.tables)
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # for_each = var.tables
  # enabled = each.value.enabled
  enabled = var.enabled
  # insert required variables here
  namespace = "stt"
  project   = "sparq"
  # region      = var.location
  # fix workspace environments to use global application name variable
  name = "${var.storage_application_name}-${var.tables[count.index]}"
  # attributes          = ["${each.key}"]
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^a-z0-9-]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "storage_table",
    "Environment"       = var.env
  }, var.additional_stt_tags)

  context = module.this.context
}

module "module_label_storage_queue" {
  count = length(var.queues)
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # for_each = var.queues
  # enabled = each.value.enabled
  enabled = var.enabled
  # insert required variables here
  namespace = "stq"
  project   = "sparq"
  # region      = var.location
  # fix workspace environments to use global application name variable
  name = "${var.storage_application_name}-${var.queues[count.index]}"
  # attributes          = ["${each.key}"]
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^a-z0-9-]/"

  tags = merge(var.tags, {
    "DeploymentSubType" = "storage_queue",
    "Environment"       = var.env
  }, var.additional_stq_tags)

  context = module.this.context
}

# module "module_label_log_analytics_workspace" {
#   ############
#   # registry #
#   source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
#   version = "0.1.0"
#   ############
#   for_each = var.log_analytics_workspace_environments
#   enabled = each.value.enabled
#   # insert required variables here
#   namespace   = "log"
#   project = "sparq"
#   region      = var.location
#   # fix workspace environments to use global application name variable
#   name                = var.application_name
#   attributes          = ["${each.key}"]
#   delimiter           = "-"
#   regex_replace_chars = "/[^a-zA-Z0-9-]/"

#   context = module.this.context
# }
