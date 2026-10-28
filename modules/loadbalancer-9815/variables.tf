variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "backend_vm_ids" {
  description = "IDs of backend VMs"
  type        = map(string)
}

variable "backend_nic_ids" {
  description = "Network Interface IDs of backend VMs"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
