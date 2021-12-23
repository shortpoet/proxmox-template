# Labels and Tags
module "module_label_resource_group" {
  ############
  # registry #
  source  = "app.terraform.io/sparq/module_label/facilisgroup//modules"
  version = "0.1.0"
  ############
  # insert required variables here
  enabled             = var.enabled_for_deployment
  namespace           = "rg"
  project             = "sparq"
  name                = var.application_name
  region              = var.resource_group_location
  attributes          = ["${var.env}"]
  delimiter           = "-"
  regex_replace_chars = "/[^-a-zA-Z0-9_]/"
  tags = merge(var.tags, {
    "DeploymentSubType" = "resource_group",
    "Environment"       = var.env
  }, var.additional_rg_tags)
}

# Create the Azure Resource Group
resource "azurerm_resource_group" "main" {
  count    = module.module_label_resource_group.enabled ? 1 : 0
  name     = module.module_label_resource_group.id
  location = module.module_label_resource_group.region
  tags     = module.module_label_resource_group.tags
}

