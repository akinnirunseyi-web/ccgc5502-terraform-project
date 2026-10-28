output "server_name" {
  description = "Name of PostgreSQL Database Server"
  value       = azurerm_postgresql_flexible_server.postgres.name
}

output "server_fqdn" {
  description = "FQDN of PostgreSQL Database Server"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_name" {
  description = "Name of the Database"
  value       = azurerm_postgresql_flexible_server_database.appdb.name
}

output "server_id" {
  description = "ID of PostgreSQL Database Server"
  value       = azurerm_postgresql_flexible_server.postgres.id
}
