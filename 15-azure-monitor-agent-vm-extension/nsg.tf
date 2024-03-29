## network network security group
resource "azurerm_network_security_group" "nsg1" {
  name                = "${local.prefix}-nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  tags = merge(local.tags, tomap({ "firstapply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags]
  }
}

## network network security group rupe allowinf inbound traffic
resource "azurerm_network_security_rule" "i1000" {
  name                        = "rdp-from-home"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = var.allowed_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}
