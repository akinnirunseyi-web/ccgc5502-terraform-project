output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_name" {
  description = "Name of the Subnet"
  value       = azurerm_subnet.subnet.name
}

output "subnet_id" {
  description = "ID of the Subnet"
  value       = azurerm_subnet.subnet.id
}

output "nsg_name" {
  description = "Name of the Network Security Group"
  value       = azurerm_network_security_group.nsg.name
}

output "nsg_id" {
  description = "ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg.id
}
