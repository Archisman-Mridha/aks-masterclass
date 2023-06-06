terraform {
  required_version = "1.4.6"

  backend "local" { }

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.59.0"
    }
  }
}

provider "azurerm" {
  use_cli = true

  features { }
}