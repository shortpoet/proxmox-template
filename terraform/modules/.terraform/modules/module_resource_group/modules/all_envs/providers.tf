# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
    tfe = {
      version = "~> 0.26.0"
    }
  }
}
provider "azurerm" {
  features {
  }
  subscription_id = var.azure_subscription_id_stg
  alias           = "stg"
}
provider "azurerm" {
  features {
  }
  subscription_id = var.azure_subscription_id_dev
  alias           = "dev"
}

provider "azurerm" {
  features {
  }
  subscription_id = var.azure_subscription_id_prd
  alias           = "prd"
}
