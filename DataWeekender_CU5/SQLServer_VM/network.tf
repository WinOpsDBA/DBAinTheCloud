## network virtual network

resource "azurerm_virtual_network" "vn1" {
  name                = "${local.prefix}-vn"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = [var.vnets[var.location]]

  tags = merge(var.tags, tomap({ "FirstApply" = timestamp(), "LastApply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

## network subnets

resource "azurerm_subnet" "sn1" {
  name                 = "${local.prefix}-sn1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vn1.name
  address_prefixes     = [local.sn1_address_prefix]
  service_endpoints    = ["Microsoft.Storage"]
}

# nsg binding

resource "azurerm_subnet_network_security_group_association" "nsg_to_sn1" {
  subnet_id                 = azurerm_subnet.sn1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

## network public ip

resource "azurerm_public_ip" "pip1" {
  count                   = var.server_count
  name                    = "${local.prefix}-sql${count.index + 1}-pip1"
  location                = azurerm_resource_group.rg1.location
  resource_group_name     = azurerm_resource_group.rg1.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = merge(var.tags, tomap({ "FirstApply" = timestamp(), "LastApply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}