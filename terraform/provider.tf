terraform {
  required_version = ">= 1.2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.0"
    }
  }

  # Local backend by default. To use remote backend (Azure Storage), replace this block
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
