resource "azurerm_virtual_network" "yocto" {
  name                = "codelab-${var.teamName}-network"
  resource_group_name = "${azurerm_resource_group.yocto.name}"

  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "yocto" {
  name                 = "codelab-${var.teamName}"
  resource_group_name  = "${azurerm_resource_group.yocto.name}"

  virtual_network_name = "${azurerm_virtual_network.yocto.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "yocto" {
  name                         = "codelab-${var.teamName}-ip"
  resource_group_name          = "${azurerm_resource_group.yocto.name}"
  location                     = "${var.location}"

  allocation_method            = "Dynamic"
}
