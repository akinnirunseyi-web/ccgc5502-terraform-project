output "loadbalancer_id" {
  description = "ID of Load Balancer"
  value       = azurerm_lb.lb.id
}

output "loadbalancer_name" {
  description = "Name of Load Balancer"
  value       = azurerm_lb.lb.name
}

output "loadbalancer_public_ip" {
  description = "Public IP of Load Balancer"
  value       = azurerm_public_ip.lb_pip.ip_address
}
