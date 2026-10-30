# Null provisioner: displays the hostname of each Linux VM after it is created
resource "null_resource" "linux_hostname" {
  for_each = local.linux_vm_names

  triggers = {
    vm_id = azurerm_linux_virtual_machine.linux_vm[each.key].id
  }

  provisioner "remote-exec" {
    inline = [
      "hostname"
    ]

    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = file(replace(var.public_key_path, ".pub", ""))
      host        = azurerm_public_ip.linux_pip[each.key].ip_address
    }
  }
}