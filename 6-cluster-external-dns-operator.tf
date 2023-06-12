resource "azurerm_user_assigned_identity" "cluster_external_dns_operator" {
  name = "cluster-external-dns-operator"

  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
}

resource "azurerm_role_assignment" "cluster_external_dns_operator" {
  principal_id = azurerm_user_assigned_identity.cluster_external_dns_operator.principal_id

  role_definition_name = "Contributor"
  scope = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}"
}