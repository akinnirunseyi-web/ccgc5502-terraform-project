output "vm_id" {
  description = "ID of Windows VM"
  value       = azurerm_windows_virtual_machine.windows_vm[0].id
}

output "vm_name" {
  description = "Name of Windows VM"
  value       = azurerm_windows_virtual_machine.windows_vm[0].name
}

output "vm_hostname" {
  description = "Hostname of Windows VM"
  value       = azurerm_windows_virtual_machine.windows_vm[0].computer_name
}

output "vm_private_ip" {
  description = "Private IP address of Windows VM"
  value       = azurerm_network_interface.windows_nic.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of Windows VM"
  value       = azurerm_public_ip.windows_pip[0].ip_address
}

output "vm_fqdn" {
  description = "FQDN of Windows VM"
  value       = azurerm_public_ip.windows_pip[0].fqdn
}
