# Availability Set for Linux VMs
resource "azurerm_availability_set" "linux_avset" {
  name                        = "9815-linux-avset"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  platform_fault_domain_count = 2
  tags                        = var.tags
}

# Local variables for VM names using for_each
locals {
  linux_vm_names = {
    vm1 = "9815-linux-vm1"
    vm2 = "9815-linux-vm2"
    vm3 = "9815-linux-vm3"
  }
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

# Associate NSG with Linux NICs
resource "azurerm_network_interface_security_group_association" "linux_nsg_assoc" {
  for_each                  = local.linux_vm_names
  network_interface_id      = azurerm_network_interface.linux_nic[each.key].id
  network_security_group_id = var.nsg_id
}

# Public IPs for Linux VMs
resource "azurerm_public_ip" "linux_pip" {
  for_each            = local.linux_vm_names
  name                = "${each.value}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "9815-${each.key}"
  tags                = var.tags
}

# Linux Virtual Machines (CentOS 8.2)
resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each            = local.linux_vm_names
  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  availability_set_id = azurerm_availability_set.linux_avset.id

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
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2-gen2"
    version   = "latest"
  }

  tags = var.tags

  provisioner "remote-exec" {
    inline = [
      "whoami",
      "hostname",
      "date"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = file(replace(var.public_key_path, ".pub", ""))
      host        = azurerm_public_ip.linux_pip[each.key].ip_address
    }
  }
}

# Network Watcher Agent Extension for Linux
resource "azurerm_virtual_machine_extension" "linux_nw_agent" {
  for_each            = local.linux_vm_names
  name                = "NetworkWatcherAgentLinux"
  virtual_machine_id  = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher           = "Microsoft.Azure.NetworkWatcher"
  type                = "NetworkWatcherAgentLinux"
  type_handler_version = "1.4"
  auto_upgrade_minor_version = true
  tags                = var.tags
}

# Azure Monitor Agent Extension for Linux
resource "azurerm_virtual_machine_extension" "linux_monitor_agent" {
  for_each            = local.linux_vm_names
  name                = "AzureMonitorLinuxAgent"
  virtual_machine_id  = azurerm_linux_virtual_machine.linux_vm[each.key].id
  publisher           = "Microsoft.Azure.Monitor"
  type                = "AzureMonitorLinuxAgent"
  type_handler_version = "1.0"
  auto_upgrade_minor_version = true
  tags                = var.tags
}
