################
# Main Outputs #
################

output "ids" {
  value = {
    stg = module.resource_group_stg.id
    dev = module.resource_group_dev.id
    prd = module.resource_group_prd.id
  }
  description = "A per-environment mapping of the ID of the Resource Group."
}

output "names" {
  value = {
    stg = module.resource_group_stg.name
    dev = module.resource_group_dev.name
    prd = module.resource_group_prd.name
  }

  description = "A per-environment mapping of the name of the Resource Group."
}

output "locations" {
  value = {
    stg = module.resource_group_stg.location
    dev = module.resource_group_dev.location
    prd = module.resource_group_prd.location
  }

  description = "A per-environment mapping of the location of the Resource Group."
}

#################
# Debug Outputs #
#################

output "tags" {
  value = var.debug_outputs ? {
    stg = module.resource_group_stg.tags
    dev = module.resource_group_dev.tags
    prd = module.resource_group_prd.tags
  } : null

  description = "A per-environment mapping of the tags of the ."
}
