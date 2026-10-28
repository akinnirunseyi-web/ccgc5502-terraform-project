# Azure Subscription
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

# Location
variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "indiasouthcentral"
}

# Environment
variable "environment_suffix" {
  description = "Suffix for resource names to ensure uniqueness"
  type        = string
  default     = "prod"
}

# Owner/User Information - CORRECTED TO YOUR NAME
variable "owner_name" {
  description = "Owner name for tags"
  type        = string
  default     = "Oluwaseyi.Akinnirun"
}

# Network Configuration
variable "vnet_cidr" {
  description = "CIDR block for Virtual Network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Linux VM Configuration
variable "linux_vm_size" {
  description = "Size of Linux VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "linux_vm_count" {
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

# Windows VM Configuration
variable "windows_vm_size" {
  description = "Size of Windows VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_password" {
  description = "Admin password for Windows VM"
  type        = string
  sensitive   = true
}

# Data Disk Configuration
variable "datadisk_size" {
  description = "Size of each data disk in GB"
  type        = number
  default     = 10
}

variable "datadisk_count" {
  description = "Number of data disks to create"
  type        = number
  default     = 4
}

# Database Configuration
variable "db_admin_username" {
  description = "Database admin username"
  type        = string
  default     = "dbadmin"
}

variable "db_admin_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}
