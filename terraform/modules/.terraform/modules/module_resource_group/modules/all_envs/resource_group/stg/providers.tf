# # Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 2.65"
      configuration_aliases = [azurerm.stg]
    }
  }
}

provider "azurerm" {
  features {
  }
}
