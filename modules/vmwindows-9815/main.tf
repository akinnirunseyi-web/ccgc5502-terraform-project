# Availability Set for Windows VM
resource "azurerm_availability_set" "windows_avset" {
  name                        = "9815-windows-avset"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  platform_fault_domain_count = 2
  tags                        = var.tags
}

# Public IP for Windows VM
resource "azurerm_public_ip" "windows_pip" {
  count               = 1
  name                = "9815-windows-vm-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "winvm9815abc"
  tags                = var.tags
}

# Network Interface for Windows VM
resource "azurerm_network_interface" "windows_nic" {
  name                = "9815-windows-vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_pip[0].id
  }

  tags = var.tags
}

# Windows Virtual Machine (Windows Server 2022 Gen2)
resource "azurerm_windows_virtual_machine" "windows_vm" {
  count               = 1
  name                = "9815-windows-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size

  availability_set_id = azurerm_availability_set.windows_avset.id

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.windows_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }

  boot_diagnostics {
    storage_account_uri = var.boot_diagnostics_storage_uri
  }

  tags = var.tags
}

# Antimalware Extension for Windows
resource "azurerm_virtual_machine_extension" "windows_antimalware" {
  count                      = 1
  name                       = "IaaSAntimalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vm[0].id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true
  tags                       = var.tags
}