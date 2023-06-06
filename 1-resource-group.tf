resource "azurerm_resource_group" "this" {
  name = "main"
  location = "Central India"

  tags = {
    "Project" = "aks-masterclass"
  }
}