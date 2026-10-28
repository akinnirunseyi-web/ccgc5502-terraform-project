# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "9815-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Load Balancer
resource "azurerm_lb" "lb" {
  name                = "9815-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

  tags = var.tags
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackEndAddressPool"
}

# Associate NICs with Backend Pool
resource "azurerm_network_interface_backend_address_pool_association" "nic_pool_assoc" {
  for_each                = var.backend_nic_ids
  network_interface_id    = each.value
  ip_configuration_name   = "testConfiguration"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

# Health Probe
resource "azurerm_lb_probe" "http_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "HTTP-Probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# Load Balancing Rule (HTTP)
resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "HTTP-Rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.http_probe.id
}
