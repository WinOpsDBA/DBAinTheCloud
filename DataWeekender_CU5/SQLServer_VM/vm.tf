## network interface
resource "azurerm_network_interface" "nic1" {
  count               = var.server_count
  name                = "${local.prefix}-sql${count.index + 1}-nic1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "${local.prefix}-sql${count.index + 1}-ip1"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip1.*.id, count.index)
  }

  tags = merge(var.tags, tomap({ "FirstApply" = timestamp(), "LastApply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

# create virtual machine
resource "azurerm_virtual_machine" "vm1" {
  count                         = var.server_count
  name                          = "${local.prefix}-sql${count.index + 1}"
  location                      = azurerm_resource_group.rg1.location
  resource_group_name           = azurerm_resource_group.rg1.name
  network_interface_ids         = [element(azurerm_network_interface.nic1.*.id, count.index)]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "sql2019-ws2019"
    sku       = "SQLDEV"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix}-sql${count.index + 1}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix}-sql${count.index + 1}"
    admin_username = var.adminusername
    admin_password = var.adminpassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = merge(var.tags, tomap({ "FirstApply" = timestamp(), "LastApply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }

}

resource "azurerm_network_interface_security_group_association" "sg_association" {
  count                     = var.server_count
  network_interface_id      = element(azurerm_network_interface.nic1.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.nsg1.id
}
