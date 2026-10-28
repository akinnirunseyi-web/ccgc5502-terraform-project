# Locals for common tagging
locals {
  common_tags = {
    Project        = "CCGC 5502 Terraform Project"
    Name           = var.owner_name
    ExpirationDate = "2027-12-31"
    Environment    = "Learning"
  }
}

# Resource Group Module
module "rgroup" {
  source = "./modules/rgroup-9815"

  resource_group_name = "9815-rg"
  location            = var.location
  
  tags = local.common_tags
}

# Network Module
module "network" {
  source = "./modules/network-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  vnet_name       = "9815-vnet"
  vnet_cidr       = var.vnet_cidr
  subnet_name     = "9815-subnet"
  subnet_cidr     = var.subnet_cidr
  nsg_name        = "9815-nsg"
  
  tags = local.common_tags
}

# Common Services Module
module "common" {
  source = "./modules/common-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  storage_account_name         = "sa9815${var.environment_suffix}"
  log_analytics_workspace_name = "law-9815"
  recovery_vault_name          = "rv-9815"
  
  tags = local.common_tags
}

# Linux VMs Module
module "vmlinux" {
  source = "./modules/vmlinux-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  subnet_id               = module.network.subnet_id
  nsg_id                  = module.network.nsg_id
  storage_account_id      = module.common.storage_account_id
  log_analytics_workspace_id = module.common.log_analytics_workspace_id
  
  vm_size                 = var.linux_vm_size
  vm_count                = var.linux_vm_count
  admin_username          = var.admin_username
  public_key_path         = var.public_key_path
  
  tags = local.common_tags
}

# Windows VM Module
module "vmwindows" {
  source = "./modules/vmwindows-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  subnet_id          = module.network.subnet_id
  nsg_id             = module.network.nsg_id
  storage_account_id = module.common.storage_account_id
  
  vm_size       = var.windows_vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password
  
  tags = local.common_tags
}

# Data Disks Module
module "datadisk" {
  source = "./modules/datadisk-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  disk_size_gb = var.datadisk_size
  disk_count   = var.datadisk_count
  
  vm_linux_ids   = module.vmlinux.vm_ids
  vm_windows_ids = [module.vmwindows.vm_id]
  
  tags = local.common_tags
}

# Load Balancer Module
module "loadbalancer" {
  source = "./modules/loadbalancer-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  subnet_id           = module.network.subnet_id
  backend_vm_ids      = module.vmlinux.vm_ids
  backend_nic_ids     = module.vmlinux.nic_ids
  
  tags = local.common_tags
}

# Database Module
module "database" {
  source = "./modules/database-9815"

  resource_group_name = module.rgroup.resource_group_name
  location            = var.location
  
  server_name    = "db-9815"
  database_name  = "appdb"
  admin_username = var.db_admin_username
  admin_password = var.db_admin_password
  
  tags = local.common_tags
}
