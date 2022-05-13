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

resource "azurerm_linux_virtual_machine" "vm1" {
  count               = var.server_count
  name                = "${local.prefix}-sql${count.index + 1}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  size                = var.vm_size_sql
  network_interface_ids = [
    element(azurerm_network_interface.nic1.*.id, count.index)
  ]

  admin_username                  = var.adminusername
  admin_password                  = var.adminpassword
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "sh1" {
  count                = var.server_count
  name                 = "${local.prefix}-vm${count.index + 1}-sh1s"
  virtual_machine_id   = element(azurerm_linux_virtual_machine.vm1.*.id, count.index)
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROTECTED_SETTINGS
    {
        "script": "${base64encode(templatefile("mssql_express_install.sh", { sqladmin = "${var.adminusername}", sqlpassword = "${var.adminpassword}", sqlport = "${var.sql_server_port}" }))}"
    }
  PROTECTED_SETTINGS

}
