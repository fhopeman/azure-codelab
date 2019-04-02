resource "azurerm_resource_group" "yocto" {
  name     = "codelab-${var.teamName}"
  location = "${var.location}"
}
