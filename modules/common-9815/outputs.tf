output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_id" {
  description = "ID of the Storage Account"
  value       = azurerm_storage_account.storage.id
}

output "log_analytics_workspace_name" {
  description = "Name of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.name
}

output "log_analytics_workspace_id" {
  description = "ID of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "recovery_vault_name" {
  description = "Name of Recovery Services Vault"
  value       = azurerm_recovery_services_vault.recovery_vault.name
}

output "recovery_vault_id" {
  description = "ID of Recovery Services Vault"
  value       = azurerm_recovery_services_vault.recovery_vault.id
}

output "storage_account_primary_blob_endpoint" {
  description = "Blob endpoint of the common storage account, used for VM boot diagnostics"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}