## network virtual network

resource "azurerm_virtual_network" "vn1" {
  name                = "${local.prefix}-vn"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = ["${var.vnets["${var.location}"]}"]

  tags = merge(var.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

## network subnets

resource "azurerm_subnet" "sn1" {
  name                 = "${local.prefix}-sn1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefix       = local.sn1_address_prefix # cidrsubnet(var.vnets[azurerm_resource_group.rg1.location], var.network_size, var.network_no)
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "sn2" {
  name                 = "${local.prefix}-sn2"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefix       = local.sn2_address_prefix # cidrsubnet(var.vnets[azurerm_resource_group.rg1.location], var.network_size, var.network_no)
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "sn3" {
  name                 = "${local.prefix}-sn3"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefix       = local.sn3_address_prefix # cidrsubnet(var.vnets[azurerm_resource_group.rg1.location], var.network_size, var.network_no)
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_sn1" {
  subnet_id                 = azurerm_subnet.sn1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_sn2" {
  subnet_id                 = azurerm_subnet.sn2.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_sn3" {
  subnet_id                 = azurerm_subnet.sn3.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
