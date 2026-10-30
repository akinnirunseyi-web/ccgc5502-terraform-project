# Local variables for VM names and zones (for_each keys)
locals {
  linux_vm_names = {
    vm1 = "9815-linux-vm1"
    vm2 = "9815-linux-vm2"
    vm3 = "9815-linux-vm3"
  }

  linux_vm_zones = {
    vm1 = "1"
    vm2 = "2"
    vm3 = "3"
  }
}

# Public IPs for Linux VMs (each in the same zone as its VM)
resource "azurerm_public_ip" "linux_pip" {
  for_each            = local.linux_vm_names
  name                = "${each.value}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [local.linux_vm_zones[each.key]]
  domain_name_label   = "linux${each.key}9815"
  tags                = var.tags
}

# Network Interfaces for Linux VMs
resource "azurerm_network_interface" "linux_nic" {
  for_each            = local.linux_vm_names
  name                = "${each.value}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_pip[each.key].id
  }

  tags = var.tags
}

# Linux Virtual Machines (Ubuntu 24.04 LTS Gen2), one per availability zone
resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each            = local.linux_vm_names
  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  zone                = local.linux_vm_zones[each.key]

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  network_interface_ids = [
    azurerm_network_interface.linux_nic[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  tags = var.tags
}

# Network Watcher Agent Extension for Linux
resource "azurerm_virtual_machine_extension" "linux_nw_agent" {
  for_each                   = local.linux_vm_names
  name                       = "NetworkWatcherAgentLinux"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}

# Azure Monitor Agent Extension for Linux
resource "azurerm_virtual_machine_extension" "linux_monitor_agent" {
  for_each                   = local.linux_vm_names
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}