# # Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 2.65"
      configuration_aliases = [azurerm.dev]
    }
    # azuread = {
    #   source  = "hashicorp/azuread"
    #   version = ">= 2.2.1"
    # }

    # azurecaf provider is legit to use here because it is not used in calling module so doesn't throw
    # https://dev.azure.com/fg-sparq/IaC-Modules/_build/results?buildId=253&view=logs&j=c0a661bf-ccbc-59b8-182f-89e8fcf30e8f&t=d13baf70-06db-5804-7fac-2af59df96f2c&l=278
    # `
    # │ Error: Module module.module_keyvault contains provider configuration
    # │ 
    # │ Providers cannot be configured within modules using count, for_each or
    # │ depends_on.
    # `
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">=1.2.6"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = ">= 3.1.0"
    # }
  }
}

provider "azurerm" {
  features {

  }
}
