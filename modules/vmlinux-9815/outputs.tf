output "vm_ids" {
  description = "IDs of Linux VMs"
  value = {
    for key, vm in azurerm_linux_virtual_machine.linux_vm : key => vm.id
  }
}

output "vm_names" {
  description = "Names of Linux VMs"
  value = {
    for key, vm in azurerm_linux_virtual_machine.linux_vm : key => vm.name
  }
}

output "vm_hostnames" {
  description = "Hostnames of Linux VMs"
  value = {
    for key, vm in azurerm_linux_virtual_machine.linux_vm : key => vm.computer_name
  }
}

output "vm_private_ips" {
  description = "Private IP addresses of Linux VMs"
  value = {
    for key, nic in azurerm_network_interface.linux_nic : key => nic.private_ip_address
  }
}

output "vm_public_ips" {
  description = "Public IP addresses of Linux VMs"
  value = {
    for key, pip in azurerm_public_ip.linux_pip : key => pip.ip_address
  }
}

output "vm_fqdns" {
  description = "FQDNs of Linux VMs"
  value = {
    for key, pip in azurerm_public_ip.linux_pip : key => pip.fqdn
  }
}

output "nic_ids" {
  description = "Network Interface IDs of Linux VMs"
  value = {
    for key, nic in azurerm_network_interface.linux_nic : key => nic.id
  }
}
