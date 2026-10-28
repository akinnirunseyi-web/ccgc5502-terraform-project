terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backend-9815"
    storage_account_name = "satterraform9815"
    container_name       = "tfstate"
    key                  = "ccgc5502-project.tfstate"
  }
}
