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
