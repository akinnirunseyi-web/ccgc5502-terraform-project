variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "dbadmin"
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
