# https://github.com/datarootsio/terraform-module-azure-storage-sas

locals {
  start      = time_rotating.end.rfc3339
  expiration = timeadd(time_rotating.end.rotation_rfc3339, var.rotation_margin)
}

resource "time_rotating" "end" {
  rfc3339          = var.start
  rotation_days    = var.rotation_days
  rotation_hours   = var.rotation_hours
  rotation_minutes = var.rotation_minutes
  rotation_months  = var.rotation_months
  rotation_years   = var.rotation_years
}

data "azurerm_storage_account_sas" "main" {
  count             = var.generate_sas_for_storage_account == true ? 1 : 0
  connection_string = var.connection_string
  expiry            = local.expiration
  start             = local.start
  # permissions suggested on tf registry for 
  #   -> azurerm_key_vault_managed_storage_account_sas_token_definition

  #   -> https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_managed_storage_account_sas_token_definition
  # permissions {
  #   read    = true
  #   write   = true
  #   delete  = false
  #   list    = false
  #   add     = true
  #   create  = true
  #   update  = false
  #   process = false
  # }

  permissions {
    add     = var.write
    create  = var.write
    delete  = var.write
    list    = true
    process = var.write
    read    = true
    update  = var.write
    write   = var.write
  }
  resource_types {
    container = true
    object    = true
    service   = true
  }
  services {
    blob  = true
    file  = true
    queue = true
    table = true
  }
}

data "azurerm_storage_account_blob_container_sas" "main" {
  count             = var.generate_sas_for_storage_container == true ? 1 : 0
  connection_string = var.connection_string
  container_name    = var.storage_container_name
  expiry            = local.expiration
  start             = local.start
  permissions {
    add    = var.write
    create = var.write
    delete = var.write
    list   = true
    read   = true
    write  = var.write
  }
}

output "sas" {
  description = "SAS token"
  value = (
    var.generate_sas_for_storage_account == true
    ? data.azurerm_storage_account_sas.main[0].sas
    : var.generate_sas_for_storage_container == true
    ? data.azurerm_storage_account_blob_container_sas.main[0].sas
    : null
  )
  sensitive = true
}
