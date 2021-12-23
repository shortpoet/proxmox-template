# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.86"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.10.0"
    }
  }
}
provider "azurerm" {
  features {
  }
  subscription_id = var.azure_subscription_id
}
