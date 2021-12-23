# https://github.com/kumarvna/terraform-azurerm-storage

######################
# Local Declarations #
######################
locals {
  account_tier             = (var.account_kind == "FileStorage" ? "Premium" : split("_", var.skuname)[0])
  account_replication_type = (local.account_tier == "Premium" ? "LRS" : split("_", var.skuname)[1])
  # blobs = [
  #   for b in var.blobs : merge({
  #     type         = "block"
  #     size         = 0
  #     content_type = "application/octet-stream"
  #     source_file  = null
  #     source_uri   = null
  #     attempts     = 1
  #     metadata     = {}
  #   }, b)
  # ]  
}

################################################################
# Storage Account Creation # or selection - Default is "false" #
################################################################
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_storage_account" "st_account" {
  count               = var.create_storage_account == false ? 1 : 0
  name                = module.module_label_storage_account.id
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_storage_account" "st_account" {
  count               = var.create_storage_account ? 1 : 0
  name                = module.module_label_storage_account.id
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  account_kind             = var.account_kind
  account_tier             = local.account_tier
  account_replication_type = local.account_replication_type
  access_tier              = var.access_tier

  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version
  allow_blob_public_access  = var.enable_advanced_threat_protection == true ? true : false
  tags                      = module.module_label_storage_account.tags

  dynamic "static_website" {
    for_each = var.static_website != null ? ["true"] : []
    content {
      index_document     = var.static_website.index_document
      error_404_document = var.static_website.error_404_document
    }
  }

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  blob_properties {
    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
    versioning_enabled       = var.enable_versioning
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.change_feed_enabled
  }

  # network rule issues
  #   -> https://github.com/hashicorp/terraform-provider-azurerm/issues/2977
  #   -> https://github.com/hashicorp/terraform/issues/24677
  #   -> https://stackoverflow.com/questions/63825315/terraform-azure-provider-azure-public-access-level-for-containers
  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
    }
  }
}

######################################
# Storage Advanced Threat Protection #
######################################
resource "azurerm_advanced_threat_protection" "adv_threat_prot" {
  count = 1
  target_resource_id = (
    var.create_storage_account
    ? azurerm_storage_account.st_account[count.index].id
    : data.azurerm_storage_account.st_account[count.index].id
  )
  enabled = var.enable_advanced_threat_protection
}

##############################
# Storage Container Creation #
##############################
resource "azurerm_storage_container" "st_container" {
  count                 = length(var.containers_list)
  name                  = module.module_label_storage_container[count.index].id
  storage_account_name  = azurerm_storage_account.st_account[count.index].name
  container_access_type = var.containers_list[count.index].access_type
  # `namespace`
  metadata = {
    for k, v in module.module_label_storage_container[count.index].tags :
    lower(k == "Namespace" ? "namespace_tag" : k) => v
  }
}

###########################
# Shared Access Signature #
###########################

module "module_sas" {
  source = "./sas"

  # enablement
  count                              = (var.generate_sas_for_storage_account || var.generate_sas_for_storage_container) ? 1 : 0
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

  # storage account
  connection_string = var.create_storage_account == false ? data.azurerm_storage_account.st_account[count.index].primary_connection_string : azurerm_storage_account.st_account[count.index].primary_connection_string

  # permissions
  write = var.write

  depends_on = [
    data.azurerm_storage_account.st_account,
    azurerm_storage_account.st_account
  ]

}

module "module_kv_sas" {
  source = "./kv_sas"

  # enablement
  count = var.kv_manage_sas ? 1 : 0

  # labels
  env                        = var.env
  storage_application_name   = var.storage_application_name
  key_vault_application_name = var.key_vault_application_name
  tags                       = var.tags

  # key vault
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = var.resource_group_name
  key_vault_name                = var.key_vault_name
  key_vault_resource_group_name = var.key_vault_resource_group_name
  additional_kv_tags            = var.additional_kv_tags
  sp_object_id                  = var.sp_object_id

  # storage account
  storage_account_id   = var.create_storage_account == false ? data.azurerm_storage_account.st_account[count.index].id : azurerm_storage_account.st_account[count.index].id
  storage_account_name = module.module_label_storage_account.id

  # management
  regeneration_validity_period = var.regeneration_validity_period
  sas_template_uri             = module.module_sas[0].sas
  sas_type                     = var.sas_type
  additional_stmgmt_tags       = var.additional_stmgmt_tags
  additional_stmgmtsasdef_tags = var.additional_stmgmtsasdef_tags
  depends_on = [
    data.azurerm_storage_account.st_account,
    azurerm_storage_account.st_account,
    module.module_sas
  ]
}

##############################
# Storage Fileshare Creation #
##############################
resource "azurerm_storage_share" "storage_share" {
  count                = length(var.file_shares)
  name                 = module.module_label_storage_file_share[count.index].id
  storage_account_name = azurerm_storage_account.st_account[count.index].name
  quota                = var.file_shares[count.index].quota
}

###########################
# Storage Tables Creation #
###########################
resource "azurerm_storage_table" "st_table" {
  count                = length(var.tables)
  name                 = module.module_label_storage_table[count.index].id
  storage_account_name = azurerm_storage_account.st_account[count.index].name
}

##########################
# Storage Queue Creation #
##########################
resource "azurerm_storage_queue" "st_queue" {
  count                = length(var.queues)
  name                 = module.module_label_storage_queue[count.index].id
  storage_account_name = azurerm_storage_account.st_account[count.index].name
}

################################
# Storage Lifecycle Management #
################################
resource "azurerm_storage_management_policy" "lcpolicy" {
  count              = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.st_account[count.index].id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.snapshot_delete_after_days
        }
      }
    }
  }
}

#################
# Storage Blobs #
#################

# https://github.com/innovationnorway/terraform-azurerm-storage/blob/master/variables.tf
# resource "azurerm_storage_blob" "main" {
#   count                  = length(local.blobs)
#   name                   = local.blobs[count.index].name
#   resource_group_name    = data.azurerm_resource_group.rg.name
#   storage_account_name   = azurerm_storage_account.st_account.name
#   storage_container_name = local.blobs[count.index].container_name
#   type                   = local.blobs[count.index].type
#   size                   = local.blobs[count.index].size
#   content_type           = local.blobs[count.index].content_type
#   source                 = local.blobs[count.index].source_file
#   source_uri             = local.blobs[count.index].source_uri
#   attempts               = local.blobs[count.index].attempts
#   metadata               = local.blobs[count.index].metadata
#   depends_on             = [azurerm_storage_container.st_container]
# }

###########################
# Log Analytics Workspace #
###########################

# key vault
# or
# storage
# ?
# https://github.com/avinor/terraform-azurerm-remote-backend/blob/master/main.tf
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace

# resource "azurerm_monitor_diagnostic_setting" "state" {
#   count                      = var.log_analytics_workspace_id != null ? 1 : 0
#   name                       = module.module_label_storage_account.id
#   target_resource_id         = azurerm_key_vault.kv.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   log {
#     category = "AuditEvent"

#     retention_policy {
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = false
#     }
#   }
# }