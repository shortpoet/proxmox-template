################
# Main Outputs #
################

output "service_principal_names" {
  value = {
    stg = module.service_principal_stg.service_principal_name
    dev = module.service_principal_dev.service_principal_name
    prd = module.service_principal_prd.service_principal_name
  }
  description = "A per-environment mapping of the Name of the Service Principal."
}

output "service_principal_object_ids" {
  value = {
    stg = module.service_principal_stg.service_principal_object_id
    dev = module.service_principal_dev.service_principal_object_id
    prd = module.service_principal_prd.service_principal_object_id
  }

  description = "A per-environment mapping of the service principal object id of the Service Principal."
}

output "service_principal_application_ids" {
  value = {
    stg = module.service_principal_stg.service_principal_application_id
    dev = module.service_principal_dev.service_principal_application_id
    prd = module.service_principal_prd.service_principal_application_id
  }

  description = "A per-environment mapping of the service principal application id of the Service Principal."
}

output "client_ids" {
  value = {
    stg = module.service_principal_stg.client_id
    dev = module.service_principal_dev.client_id
    prd = module.service_principal_prd.client_id
  }

  description = "A per-environment mapping of the client id of the Service Principal."
}

output "client_secrets" {
  value = {
    stg = module.service_principal_stg.client_secret
    dev = module.service_principal_dev.client_secret
    prd = module.service_principal_prd.client_secret
  }
  sensitive   = true
  description = "A per-environment mapping of the client secret of the Service Principal."
}

output "service_principal_passwords" {
  value = {
    stg = module.service_principal_stg.service_principal_password
    dev = module.service_principal_dev.service_principal_password
    prd = module.service_principal_prd.service_principal_password
  }
  sensitive   = true
  description = "A per-environment mapping of the service principal password of the Service Principal."
}
