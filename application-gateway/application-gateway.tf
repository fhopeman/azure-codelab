locals {
  backend_address_pool_name      = "${azurerm_virtual_network.yocto.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.yocto.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.yocto.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.yocto.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.yocto.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.yocto.name}-rqrt"
}

resource "azurerm_application_gateway" "yocto" {
  name                = "codelab-${var.teamName}-application-gateway"
  resource_group_name = "${azurerm_resource_group.yocto.name}"
  location            = "${azurerm_resource_group.yocto.location}"

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "ip-config"
    subnet_id = "${azurerm_subnet.applicationGateway.id}"
  }

  frontend_port {
    name = "${local.frontend_port_name}"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.applicationGateway.id}"
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "${local.request_routing_rule_name}"
    rule_type                  = "Basic"
    http_listener_name         = "${local.listener_name}"
    backend_address_pool_name  = "${local.backend_address_pool_name}"
    backend_http_settings_name = "${local.http_setting_name}"
  }

  backend_address_pool {
    name = "${local.backend_address_pool_name}"
    #ip_addresses = ["${element(azurerm_network_interface.yocto.*.private_ip_address, count.index)}"]
    #ip_addresses = ["${azurerm_virtual_machine_scale_set.yocto.id}"]
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 1
  }
}
