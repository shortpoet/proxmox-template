module "module_keyvault" {
  source  = "app.terraform.io/sparq/module_keyvault/azure"
  version = "0.1.0"
  # insert required variables here
}
module "module_label" {
  source  = "app.terraform.io/sparq/module_label/facilisgroup"
  version = "0.1.0"
  # insert required variables here
}
module "module_resource_group" {
  source  = "app.terraform.io/sparq/module_resource_group/azure"
  version = "0.1.0"
  # insert required variables here
}
module "module_service_principal" {
  source  = "app.terraform.io/sparq/module_service_principal/azure"
  version = "0.1.0"
  # insert required variables here
}
module "module_storage" {
  source  = "app.terraform.io/sparq/module_storage/azure"
  version = "0.1.0"
  # insert required variables here
}
module "module_workspace" {
  source  = "app.terraform.io/sparq/module_workspace/hashicorp"
  version = "0.1.0"
  # insert required variables here
}
