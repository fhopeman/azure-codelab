resource "azurerm_storage_account" "yocto" {
  name                = "codelab${var.teamName}storage"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  account_replication_type = "LRS"
  account_tier = "Standard"
}

resource "azurerm_virtual_machine_scale_set" "yocto" {
  name                = "codelab-${var.teamName}-scale-set"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_DS1_v2"
    tier     = "Standard"
    capacity = 2
  }

  os_profile {
    computer_name_prefix = "codelab-${var.teamName}-yocto-"
    admin_username       = "azureuser"
    custom_data = "${file("../scripts/start-yocto.sh")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file("${var.sshPublicKeyPath}")}"
    }
  }

  network_profile {
    name    = "networkProfile"
    primary = true

    ip_configuration {
      name      = "ipConfig"
      primary   = true
      subnet_id = "${azurerm_subnet.yocto.id}"
      application_gateway_backend_address_pool_ids =  ["${azurerm_application_gateway.yocto.backend_address_pool.0.id}"]
    }
  }

  storage_profile_os_disk {
    caching        = "ReadWrite"
    create_option  = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.yocto.primary_blob_endpoint}"
  }
}
