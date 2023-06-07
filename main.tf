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

/* module "azure-mysql-server" {
  source = "./modules/azure-mysql-server"

  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location

  demo_azure_sql_server_admin_password = var.demo_azure_sql_server_admin_password
} */

/* module "azure-file-shares" {
  source = "./modules/azure-file-shares"
} */