# terraform-azure-module_storage

## Microsoft Storage Docs

- [Configure anonymous public read access for containers and blobs](https://docs.microsoft.com/en-us/azure/storage/blobs/anonymous-read-access-configure?tabs=portal)
- [About anonymous public read access - blob, container, private](https://docs.microsoft.com/en-us/azure/storage/blobs/anonymous-read-access-configure?tabs=portal#about-anonymous-public-read-access)
- [About Azure Key Vault managed storage account keys](https://docs.microsoft.com/en-us/azure/key-vault/secrets/about-managed-storage-account-keys)

## Terraform Docs

- [time provider](https://registry.terraform.io/providers/hashicorp/time/latest)

## examples

- [kumarvna/terraform-azurerm-storage Public](https://github.com/kumarvna/terraform-azurerm-storage)
  - programmatic resource_group creation
  - dynamic tier and replication type selection
  - network_rules object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) }), object({ bypass = list(string), ip_rules = list(string), subnet_ids = list(string) })
  - containers_list list(object({ name = string, access_type = string }))
  - file_shares list(object({ name = string, quota = number }))
  - queues list(string)
  - tables list(string)
  - lifecycles list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  - identity_ids -> Specifies a list of user managed identity ids to be assigned. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`, storage lifecycle azurerm_storage_management_policy (dynamic(rule(content(filters), actions)))
- [innovationnorway/terraform-azurerm-storage Public archive](https://github.com/innovationnorway/terraform-azurerm-storage)
  - blobs upload list(any(lots of metadata)), similar to kumarvna
- [datarootsio/terraform-module-azure-storage-sas Public](https://github.com/datarootsio/terraform-module-azure-storage-sas)
  - backend storage
  - **TESTS**
  - time_rotating provider for sas key rotation
- [Umanis/terraform-azurerm-storage-account Public](https://github.com/Umanis/terraform-azurerm-storage-account)
  - azurecaf_name (instance_index format, list(caf_prefixes))
  - dynamic [static_website, blob properties, network_rules]
  - azurerm_advanced_threat_protection
  - list(object({ name = string, access_type = string })) [containers_list, file_shares, file_shares, file_shares]
- [avinor/terraform-azurerm-remote-backend Public](https://github.com/avinor/terraform-azurerm-remote-backend)
  - **TESTS**
  - external data provider (az ad signed-in-user query)
  - azurerm_monitor_diagnostic_setting, azurerm_role_assignment, null_resource" "generate_sas_definition" { provisioner "local-exec" { command = "${path.module}/generate-sas-definition.sh }
  - key_vault
  - access_policies list(object({ object_id = string, certificate_permissions = list(string), key_permissions = list(string), secret_permissions = list(string) }))
- [dfar-io/terraform-azurerm-storage-account Public](https://github.com/dfar-io/terraform-azurerm-storage-account)
  - static website double check - could do in variables validation
- [claranet/terraform-azurerm-storage-sas-tokenPublic](https://github.com/claranet/terraform-azurerm-storage-sas-token)
  - different sas token script
  - dynamic query built in terraform for script
  - jsonencode sas token in locals
  - sas uri interpolation
  - data external example with script file
  - [resource_group lock, variable-{type}.tf example](https://github.com/claranet/terraform-azurerm-rg)
  - container_permissions 'query' in external data sources for script file generate-sas command
- [rhythmictech/terraform-azurerm-storage-account Public](https://github.com/rhythmictech/terraform-azurerm-storage-account)
  - azurerm_monitor_metric_alert (action, criteria, dynamic(dimension))
- [adfinis-sygroup/terraform-azurerm-backupstorage Public](https://github.com/adfinis-sygroup/terraform-azurerm-backupstorage)
  - random_id (keepers that when changed trigger new random id)
  - otherwise basic
- [jungopro/terraform-azurerm-static-website Public](https://github.com/jungopro/terraform-azurerm-static-website)
  - chained shell commands as workaround for previously inexistant static_website `az extension add`
- [StefanSchoof/terraform-azurerm-static-website Public](https://github.com/StefanSchoof/terraform-azurerm-static-website)
  - chained shell commands as workaround for previously inexistant static_website `az storage blob service-properties update`
- changes to address above workarounds
  - [Add support for static website to azurerm_storage_account #1903](https://github.com/hashicorp/terraform-provider-azurerm/issues/1903)
  - [CHANGELOG 2.0.0 (February 24, 2020)](https://github.com/hashicorp/terraform-provider-azurerm/blob/v2.0.0/CHANGELOG.md)

## progress

- v0.1.0

### TODO

- TODO move examples up a directory level

### commands

- import managed storage account

```powershell
terraform import -var-file .\dev.tfvars module.module_storage_account.module.module_kv_sas[0].azurerm_key_vault_managed_storage_account.kv_mng_st_acc[0] https://kv-rg-sparq-dev-infra.vault.azure.net/storage/st8sparq8sasuse8dev
```

- remove managed storage account

```powershell
az keyvault storage remove --name st8sparq8sasuse8dev --vault-name kv-rg-sparq-dev-infra
```
