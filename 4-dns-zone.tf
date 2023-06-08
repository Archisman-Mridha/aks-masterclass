// TODO: Use a separate resource group for managing DNS Zones

// TODO: After the DNZ Zone is created in Azure, add the new nameservers in the
// domain registrar.
resource "azurerm_dns_zone" "this" {
  name = "projectsofarchi.live"

  resource_group_name = azurerm_resource_group.this.name
}