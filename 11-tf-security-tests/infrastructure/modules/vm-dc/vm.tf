
## network public ip

resource "azurerm_public_ip" "pip1" {
  name                    = "${var.prefix}-dc1-pip1"
  location                = var.location
  resource_group_name     = var.rg_name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = merge(var.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }
}

## network interface

resource "azurerm_network_interface" "nic1" {
  name                = "${var.prefix}-dc1-nic1"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${var.prefix}-dc1-ip1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip_address_dc
    public_ip_address_id          = azurerm_public_ip.pip1.id
  }

  tags = merge(var.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }
}

# create virtual machine
resource "azurerm_virtual_machine" "vm1" {
  name                          = "${var.prefix}-dc1"
  location                      = var.location
  resource_group_name           = var.rg_name
  network_interface_ids          = [azurerm_network_interface.nic1.id]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-core-smalldisk-g2"
    # sku     = "2019-datacenter-smalldisk-g2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-dc1-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-dc1"
    admin_username = var.adminusername
    admin_password = var.adminpassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = merge(var.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }

}

resource "azurerm_virtual_machine_extension" "ps1" {
  name                       = "${var.prefix}-dc1-localPS"
  virtual_machine_id         = azurerm_virtual_machine.vm1.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "fileUris":["https://${var.storage_name}.blob.core.windows.net/scripts/dc-install.ps1"]
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File dc-install.ps1 ${var.domain_name} ${var.adminpassword} ${var.servicepassword}"
    }
  PROTECTED_SETTINGS

  depends_on = [azurerm_virtual_machine.vm1]

  tags = merge(var.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }

}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = var.network_security_group_id
}
