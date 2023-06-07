resource "azurerm_mysql_server" "this" {
  name = "archi-demoserver-aksmasterclass"

  resource_group_name = azurerm_resource_group.this.name
  location = azurerm_resource_group.this.location

  version = "5.7"

  storage_mb = 5120
  // The underlying compute instance will be of type "Basic" and will have 1 vCore (5th generation).
  sku_name = "B_Gen5_1"

  auto_grow_enabled = false

  administrator_login = "dbadmin"
  administrator_login_password = var.demo_azure_sql_server_admin_password
  ssl_enforcement_enabled = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"
}

resource "azurerm_mysql_firewall_rule" "azure_services" {
  name = "AzureServices"

  resource_group_name = azurerm_resource_group.this.name

  server_name = azurerm_mysql_server.this.name

  // This allows Azure services to access the MySQL server.
  start_ip_address = "0.0.0.0"
  end_ip_address = "0.0.0.0"
}