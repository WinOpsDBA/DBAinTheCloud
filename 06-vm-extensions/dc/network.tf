## network virtual network

resource "azurerm_virtual_network" "vn1" {
  name                = "${local.prefix}-vn"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["${var.vnets["${var.location}"]}"]

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

## network subnet

resource "azurerm_subnet" "sn1" {
  name                 = "${local.prefix}-sn"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefix       = cidrsubnet(var.vnets[var.location], var.network_size, var.network_no)
  service_endpoints    = ["Microsoft.Storage"]
}
