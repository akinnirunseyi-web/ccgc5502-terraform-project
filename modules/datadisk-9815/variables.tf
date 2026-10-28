variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "disk_size_gb" {
  description = "Size of each data disk in GB"
  type        = number
  default     = 10
}

variable "disk_count" {
  description = "Number of data disks to create"
  type        = number
  default     = 4
}

variable "vm_linux_ids" {
  description = "IDs of Linux VMs"
  type        = map(string)
}

variable "vm_windows_ids" {
  description = "IDs of Windows VMs"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
