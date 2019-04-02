resource "azurerm_storage_account" "yocto" {
  name                = "codelab${var.teamName}storage"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  account_replication_type = "LRS"
  account_tier = "Standard"
}

resource "azurerm_virtual_machine" "yocto" {
  name                             = "codelab-${var.teamName}-vm"
  resource_group_name              = "${azurerm_resource_group.yocto.name}"
  location                         = "${var.location}"

  vm_size                          = "Standard_DS1_v2"
  network_interface_ids            = ["${azurerm_network_interface.yocto.id}"]
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination    = true

  storage_os_disk {
    name              = "codelab-${var.teamName}-hdd"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "codelab-${var.teamName}"
    admin_username = "azureuser"
    custom_data = "${file("../scripts/start-yocto.sh")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("${var.sshPublicKeyPath}")}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.yocto.primary_blob_endpoint}"
  }
}
