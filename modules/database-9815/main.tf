# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  backup_retention_days  = 7
  version                = "14"
  tags                   = var.tags
}

# PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "appdb" {
  name       = var.database_name
  server_id  = azurerm_postgresql_flexible_server.postgres.id
  charset    = "UTF8"
  collation  = "en_US.utf8"
}

# Allow Azure Services Firewall Rule
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
