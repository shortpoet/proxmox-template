# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.86"
      configuration_aliases = [azurerm.stg, azurerm.dev, azurerm.prd]
    }
  }
}

provider "azurerm" {
  features {
  }
}
