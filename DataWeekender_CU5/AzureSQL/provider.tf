provider "azurerm" {

  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id     # Application ID
  client_secret   = var.client_secret # Application secret
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

terraform {
  backend "azurerm" {
    storage_account_name = "winopsdbaweudemo1storage"
    container_name       = "backendconfig"
    resource_group_name  = "d1-storage-rg"
    key                  = "dw5-sql1.terraform.tfstate"
  }
}
