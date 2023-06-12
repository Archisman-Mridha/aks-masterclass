resource "azurerm_resource_group" "main" {
  name = "main"
  location = "Central India"

  tags = {
    "Project" = "aks-masterclass"
  }
}