# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = module.rgroup.resource_group_name
}

output "resource_group_id" {
  description = "ID of the Resource Group"
  value       = module.rgroup.resource_group_id
}

# Network Outputs
output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = module.network.vnet_name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.network.vnet_id
}

output "subnet_name" {
  description = "Name of the Subnet"
  value       = module.network.subnet_name
}

output "subnet_id" {
  description = "ID of the Subnet"
  value       = module.network.subnet_id
}

# Common Services Outputs
output "storage_account_name" {
  description = "Name of the Storage Account"
  value       = module.common.storage_account_name
}

output "log_analytics_workspace_name" {
  description = "Name of Log Analytics Workspace"
  value       = module.common.log_analytics_workspace_name
}

output "recovery_vault_name" {
  description = "Name of Recovery Services Vault"
  value       = module.common.recovery_vault_name
}

# Linux VMs Outputs
output "linux_vm_ids" {
  description = "IDs of Linux VMs"
  value       = module.vmlinux.vm_ids
}

output "linux_vm_names" {
  description = "Names of Linux VMs"
  value       = module.vmlinux.vm_names
}

output "linux_vm_public_ips" {
  description = "Public IP addresses of Linux VMs"
  value       = module.vmlinux.vm_public_ips
}

output "linux_vm_private_ips" {
  description = "Private IP addresses of Linux VMs"
  value       = module.vmlinux.vm_private_ips
}

output "linux_vm_fqdns" {
  description = "FQDNs of Linux VMs"
  value       = module.vmlinux.vm_fqdns
}

# Windows VM Outputs
output "windows_vm_id" {
  description = "ID of Windows VM"
  value       = module.vmwindows.vm_id
}

output "windows_vm_name" {
  description = "Name of Windows VM"
  value       = module.vmwindows.vm_name
}

output "windows_vm_public_ip" {
  description = "Public IP of Windows VM"
  value       = module.vmwindows.vm_public_ip
}

output "windows_vm_private_ip" {
  description = "Private IP of Windows VM"
  value       = module.vmwindows.vm_private_ip
}

output "windows_vm_fqdn" {
  description = "FQDN of Windows VM"
  value       = module.vmwindows.vm_fqdn
}

# Load Balancer Outputs
output "loadbalancer_name" {
  description = "Name of Load Balancer"
  value       = module.loadbalancer.loadbalancer_name
}

output "loadbalancer_public_ip" {
  description = "Public IP of Load Balancer"
  value       = module.loadbalancer.loadbalancer_public_ip
}

# Database Outputs
output "database_server_name" {
  description = "Name of PostgreSQL Database Server"
  value       = module.database.server_name
}

output "database_server_fqdn" {
  description = "FQDN of PostgreSQL Database Server"
  value       = module.database.server_fqdn
}
