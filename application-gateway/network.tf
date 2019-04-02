resource "azurerm_virtual_network" "yocto" {
  name                = "codelab-${var.teamName}-network"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "yocto" {
  name                 = "codelab-${var.teamName}-subnet-yocto"
  resource_group_name  = "${azurerm_resource_group.yocto.name}"

  virtual_network_name = "${azurerm_virtual_network.yocto.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "applicationGateway" {
  name                 = "codelab-${var.teamName}-subnet-application-gateway"
  resource_group_name  = "${azurerm_resource_group.yocto.name}"

  virtual_network_name = "${azurerm_virtual_network.yocto.name}"
  address_prefix       = "10.0.3.0/24"
}

resource "azurerm_public_ip" "applicationGateway" {
  name                         = "codelab-${var.teamName}-ip-application-gateway"
  resource_group_name          = "${azurerm_resource_group.yocto.name}"
  location                     = "${var.location}"

  allocation_method            = "Dynamic"
}
