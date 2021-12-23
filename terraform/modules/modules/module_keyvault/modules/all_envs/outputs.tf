
output "ids" {
  value = {
    stg = module.key_vault_stg.id
    dev = module.key_vault_dev.id
    prd = module.key_vault_prd.id
  }
  description = "A per-environment mapping of the ID of the Key Vault."
}

output "names" {
  value = {
    stg = module.key_vault_stg.name
    dev = module.key_vault_dev.name
    prd = module.key_vault_prd.name
  }

  description = "A per-environment mapping of the name of the Key Vault."
}

output "uris" {
  value = {
    stg = module.key_vault_stg.uri
    dev = module.key_vault_dev.uri
    prd = module.key_vault_prd.uri
  }
  description = "A per-environment mapping of the URI of the Key Vault."
}

output "secrets" {
  value = {
    stg = module.key_vault_stg.secrets
    dev = module.key_vault_dev.secrets
    prd = module.key_vault_prd.secrets
  }

  description = "A per-environment mapping of secret names and URIs."
}

output "references" {
  value = {
    stg = module.key_vault_stg.references
    dev = module.key_vault_dev.references
    prd = module.key_vault_prd.references
  }

  description = "A per-environment mapping of Key Vault references for App Service and Azure Functions."
}

#################
# Debug Outputs #
#################

output "keyvault_environments_local" {
  value = var.debug_outputs ? local.keyvault_environments : null
}
output "keyvault_environments_var" {
  value = var.debug_outputs ? var.keyvault_environments : null
}
output "merged_local_secrets" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.merged_local_secrets
    dev = module.key_vault_dev.merged_local_secrets
    prd = module.key_vault_prd.merged_local_secrets
  } : null
  sensitive = true
}
output "access_policies_local" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.access_policies_local
    dev = module.key_vault_dev.access_policies_local
    prd = module.key_vault_prd.access_policies_local
  } : null
}
output "access_policies_var" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.access_policies_var
    dev = module.key_vault_dev.access_policies_var
    prd = module.key_vault_prd.access_policies_var
  } : null

}
output "sub_info" {
  value = var.debug_outputs ? {
    stg = module.key_vault_stg.sub_info
    dev = module.key_vault_dev.sub_info
    prd = module.key_vault_prd.sub_info
  } : null

}

###########################################
# Unused (Reference for possible changes) #
###########################################
# output "group_object_ids" {
#   value = local.group_object_ids
# }

# output "user_object_ids" {
#   value = local.user_object_ids
# }
