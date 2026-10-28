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

variable "nsg_id" {
  description = "ID of the network security group"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the storage account"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of Log Analytics Workspace"
  type        = string
}

variable "vm_size" {
  description = "Size of the VM"
  type        = string
  default     = "Standard_B2s"
}

variable "vm_count" {
  description = "Number of Linux VMs to create"
  type        = number
  default     = 3
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
