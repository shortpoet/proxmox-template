data "azurerm_client_config" "client_config" {}

####################
# Key Vault Module #
####################
module "module_keyvault" {
  count = var.key_vault_name == null ? 1 : 0

  ############
  # registry #
  # source  = "../../../terraform-azure-module_keyvault/modules"
  source  = "app.terraform.io/sparq/module_keyvault/azure//modules"
  version = "0.1.0"
  ############
  enabled_for_deployment        = var.enabled_for_deployment
  key_vault_application_name    = var.key_vault_application_name
  key_vault_resource_group_name = var.resource_group_name
  env                           = var.env

  # this requires dependency inversion ->
  # must move this query to kv module if want to use
  # for now as long as I am the one to run this, I get access
  # through default policy
  # custom_access_policies_objects = var.is_service_principal == false ? [
  #   {
  #     azure_ad_user_principal_name = data.azuread_user.user.*.user_principal_name[0]
  #     access = {
  #       secret = ["Get", "Delete"]
  #       storage = [
  #         "Get",
  #         "List",
  #         "Set",
  #         "SetSAS",
  #         "GetSAS",
  #         "DeleteSAS",
  #         "Update",
  #         "RegenerateKey"
  #       ]
  #     }
  #   }
  # ] : []
  custom_access_policies_objects = var.sp_object_id != null ? [
    {
      # the data call also requires either -target which is inconvenient for automation
      # or dependecy injection which means the key vault module uses azuread and
      # hence can't run with service principals unless they are given
      # app role permissions
      # https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration
      # https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps
      # https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-add-app-roles-in-azure-ad-apps
      # azure_ad_object_id = data.azurerm_client_config.client_config.object_id
      azure_ad_object_id = "${var.sp_object_id}"
      access = {
        secret = ["Get", "Delete"]
        storage = [
          "Get",
          "List",
          "Set",
          "SetSAS",
          "GetSAS",
          "DeleteSAS",
          "Update",
          "RegenerateKey"
        ]
      }
    }
  ] : []

  tags               = var.tags
  additional_kv_tags = var.additional_kv_tags

  debug_outputs           = false
  debug_sensitive_outputs = false
  default_secrets_enabled = false
}

resource "azurerm_role_assignment" "role_assign" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = data.azurerm_client_config.client_config.object_id
}

data "azurerm_key_vault" "kv" {
  count               = var.key_vault_name != null ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_key_vault_access_policy" "kv_add_policy" {
  count        = var.key_vault_name != null ? 1 : 0
  key_vault_id = data.azurerm_key_vault.kv.*.id[0]

  tenant_id = data.azurerm_client_config.client_config.tenant_id
  object_id = data.azurerm_client_config.client_config.object_id

  secret_permissions = ["Get", "Delete"]
  storage_permissions = [
    "Get",
    "List",
    "Set",
    "SetSAS",
    "GetSAS",
    "DeleteSAS",
    "Update",
    "RegenerateKey"
  ]
}

resource "azurerm_key_vault_managed_storage_account" "kv_mng_st_acc" {
  count = 1
  name  = var.storage_account_name
  # additionally
  # this name has to match the storage account
  # even though the verkakte docs have them as different! 😡
  # name                         = module.module_label_key_vault_managed_storage_account.id
  key_vault_id                 = var.key_vault_name != null ? data.azurerm_key_vault.kv[count.index].id : module.module_keyvault[count.index].id[0]
  storage_account_id           = var.storage_account_id
  storage_account_key          = "key1"
  regenerate_key_automatically = false
  regeneration_period          = var.regeneration_validity_period
  tags                         = module.module_label_key_vault_managed_storage_account.tags
  depends_on = [
    data.azurerm_key_vault.kv,
    module.module_keyvault
  ]
}

resource "azurerm_key_vault_managed_storage_account_sas_token_definition" "kv_mng_st_acc_sas_tok_def" {
  count = 1
  # name                         = var.storage_account_name
  # finally got to the bottom of this pesky issue!!
  # azurerm was not creating this correctly
  # only when i tried to import an existing resource
  # because it refuesed to get destroyed from a successful run
  # did this more helpful message appear
  #  Service returned an error. Status=400 Code="BadParameter" Message="Invalid sas definition name: stmgmtsasdef-sparq-sasuse-centralus-dev. Name should be between 1 to 102 characters and should contain only alphanumeric values."
  name                       = module.module_label_key_vault_managed_storage_account_sas_token_definition.id
  validity_period            = var.regeneration_validity_period
  managed_storage_account_id = azurerm_key_vault_managed_storage_account.kv_mng_st_acc[count.index].id
  sas_template_uri           = var.sas_template_uri
  sas_type                   = var.sas_type
  tags                       = module.module_label_key_vault_managed_storage_account_sas_token_definition.tags
  depends_on = [
    data.azurerm_key_vault.kv,
    module.module_keyvault,
    azurerm_key_vault_managed_storage_account.kv_mng_st_acc
  ]
}

output "kv_sas_id" {
  description = "The ID of the Key Vault Managed Storage Account."
  value       = azurerm_key_vault_managed_storage_account.kv_mng_st_acc.*.id
}

output "kv_sas_definition_id" {
  description = "The ID of the Managed Storage Account SAS Definition."
  value       = azurerm_key_vault_managed_storage_account_sas_token_definition.kv_mng_st_acc_sas_tok_def.*.id
}

output "kv_sas_secret_id" {
  description = "The ID of the Secret that is created by Managed Storage Account SAS Definition."
  value       = azurerm_key_vault_managed_storage_account_sas_token_definition.kv_mng_st_acc_sas_tok_def.*.secret_id
}