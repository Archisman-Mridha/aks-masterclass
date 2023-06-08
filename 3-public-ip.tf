resource "azurerm_public_ip" "this" {
  name = "nginx-ingress-serviceLB-ip"

  resource_group_name = azurerm_kubernetes_cluster.this.node_resource_group
  location = azurerm_resource_group.this.location

  allocation_method = "Static"
  sku = "Standard"
}