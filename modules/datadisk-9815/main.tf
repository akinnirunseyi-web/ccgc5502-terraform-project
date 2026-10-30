# Create data disks
resource "azurerm_managed_disk" "data_disk" {
  count                = var.disk_count
  name                 = "9815-datadisk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  zone                 = count.index < 3 ? tostring(count.index + 1) : null
  tags                 = var.tags
}

# Combine Linux and Windows VM IDs
locals {
  all_vm_ids = merge(
    var.vm_linux_ids,
    { for i, id in var.vm_windows_ids : "windows_${i}" => id }
  )
}

# Attach first 3 disks to Linux VMs (1 disk each)
resource "azurerm_virtual_machine_data_disk_attachment" "linux_disk_attach" {
  for_each           = { for i, id in values(var.vm_linux_ids) : i => { vm_id = id, disk_index = i } }
  managed_disk_id    = azurerm_managed_disk.data_disk[each.value.disk_index].id
  virtual_machine_id = each.value.vm_id
  lun                = 0
  caching            = "ReadWrite"
}

# Attach fourth disk to Windows VM
resource "azurerm_virtual_machine_data_disk_attachment" "windows_disk_attach" {
  count              = length(var.vm_windows_ids)
  managed_disk_id    = azurerm_managed_disk.data_disk[3].id
  virtual_machine_id = var.vm_windows_ids[count.index]
  lun                = 0
  caching            = "ReadWrite"
}
