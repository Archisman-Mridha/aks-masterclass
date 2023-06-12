resource "azurerm_resource_group" "dns_zones" {
  name = "dns-zones"
  location = "Central India"

  tags = {
    "Project" = "aks-masterclass"
  }
}

// TODO: After the DNZ Zone is created in Azure, add the new nameservers in the
// domain registrar.
resource "azurerm_dns_zone" "this" {
  name = "projectsofarchi.live"

  resource_group_name = azurerm_resource_group.dns_zones.name
}