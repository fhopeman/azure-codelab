resource "azurerm_virtual_network" "yocto" {
  name                = "codelab-${var.teamName}-network"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "yocto" {
  name                 = "codelab-${var.teamName}-subnet"
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

resource "azurerm_network_security_group" "yocto" {
  name                = "codelab-${var.teamName}-securityGroup"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "${var.myIp}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "yocto" {
  name                = "codelab-${var.teamName}-networkInterface"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${var.location}"

  network_security_group_id = "${azurerm_network_security_group.yocto.id}"

  ip_configuration {
    name                          = "nicConfiguration"
    subnet_id                     = "${azurerm_subnet.yocto.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.yocto.id}"
  }
}
