resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vmprefix1}-vm"
  location              = azurerm_resource_group.Terraform-test.location
  resource_group_name   = azurerm_resource_group.Terraform-test.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }
  storage_os_disk {
    name              = "monosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "monitor"
    admin_username = var.user1
    admin_password = var.pass1
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path = "/home/${var.user1}/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  provisioner "file" {
    connection {
        type = "ssh"
        user = var.user1
        password = var.pass1
        host = azurerm_public_ip.PubIP.ip_address
        insecure = true
    }
    source = "files/script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.user1
      //password = var.pass1
      host = azurerm_public_ip.PubIP.ip_address
      insecure = true
      private_key = file("~/.ssh/id_rsa")
      timeout = "5m"
    }
    inline = [
      "echo ${var.pass1} | sudo -S -k yum update -y",
      "echo ${var.pass1} | sudo -S -k chmod +x /tmp/script.sh",
      "echo ${var.pass1} | sudo -S -k /tmp/script.sh ${var.pass1}",
    ]
  }

  tags = {
    environment = "staging"
  }
}
