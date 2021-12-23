# Configure the Azure provider
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.7.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.1"
    }
  }
}
provider "azurerm" {
  features {
  }
  subscription_id = var.azure_subscription_id
}
