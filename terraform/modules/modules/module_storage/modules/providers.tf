terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.86"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.2"
    }
  }
}
