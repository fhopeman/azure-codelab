locals {
  backend_address_pool_name      = "appgw-beap"
  frontend_port_name             = "appgw-feport"
  frontend_ip_configuration_name = "appgw-feip"
  http_setting_name              = "appgw-be-htst"
  listener_name                  = "appgw-httplstn"
  request_routing_rule_name      = "appgw-rqrt"
  ssl_certificate_name           = "appgw-selfSignedCertificate"
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
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${local.frontend_ip_configuration_name}"
    public_ip_address_id = "${azurerm_public_ip.applicationGateway.id}"
  }

  http_listener {
    name                           = "${local.listener_name}"
    frontend_ip_configuration_name = "${local.frontend_ip_configuration_name}"
    frontend_port_name             = "${local.frontend_port_name}"
    protocol                       = "Https"
    ssl_certificate_name           = "${local.ssl_certificate_name}"
  }

  ssl_certificate {
    name = "${local.ssl_certificate_name}"
    data = "${file("../scripts/appgwcert.pfx")}"
    password = ""
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
  }

  backend_http_settings {
    name                  = "${local.http_setting_name}"
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 1
  }

  probe {
    name = "healthCheck"
    pick_host_name_from_backend_http_settings = true
    protocol = "Http"
    path = "/health"
    interval = 5
    unhealthy_threshold = 3
    timeout = 1
  }
}
