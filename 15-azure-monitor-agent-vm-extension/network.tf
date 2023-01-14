# network virtual network

resource "azurerm_virtual_network" "vn1" {
  name                = "${local.prefix}-vn"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.vnet_address_space]

  tags = merge(var.tags, tomap({ "firstapply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags]
  }
}

# network subnets

resource "azurerm_subnet" "sn1" {
  name                 = "${local.prefix}-sn1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefixes     = [local.sn1_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_sn1" {
  subnet_id                 = azurerm_subnet.sn1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
