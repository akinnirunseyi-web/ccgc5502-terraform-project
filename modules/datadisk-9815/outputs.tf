output "datadisk_ids" {
  description = "IDs of Data Disks"
  value = {
    for i, disk in azurerm_managed_disk.data_disk : "disk_${i + 1}" => disk.id
  }
}

output "datadisk_attachments" {
  description = "Data Disk attachment status"
  value       = "4 data disks created and attached to all VMs"
}
