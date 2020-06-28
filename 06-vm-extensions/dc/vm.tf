
## network public ip

resource "azurerm_public_ip" "pip1" {
  name                    = "${local.prefix}-pip1"
  location                = azurerm_resource_group.rg1.location
  resource_group_name     = azurerm_resource_group.rg1.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

## network interface

resource "azurerm_network_interface" "nic1" {
  name                      = "${local.prefix}-dc1-nic1"
  location                  = azurerm_resource_group.rg1.location
  resource_group_name       = azurerm_resource_group.rg1.name
  network_security_group_id = azurerm_network_security_group.nsg1.id

  ip_configuration {
    name                          = "${local.prefix}-dc1-ip1"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
    # private_ip_address_allocation = "Static"
    # private_ip_address = "${var.ip_address}"
    public_ip_address_id          = azurerm_public_ip.pip1.id
  }

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

# create virtual machine
resource "azurerm_virtual_machine" "vm1" {
  name                  = "${local.prefix}-dc1"
  location              = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  #network_interface_ids         = ["${element(azurerm_network_interface.nic1.*.id, count.index)}"]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    #name              = "${local.prefix}-dc${count.index + 1}-disk1"
    name              = "${local.prefix}-dc1-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    #computer_name  = "${local.prefix}-dc${count.index + 1}"
    computer_name  = "${local.prefix}-dc1"
    admin_username = var.adminusername
    admin_password = var.adminpassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }

}

resource "azurerm_virtual_machine_extension" "ps1" {
  name = "${azurerm_virtual_machine.vm1.name}-custom-ps1"
  virtual_machine_id   = azurerm_virtual_machine.vm1.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "fileUris":["https://winopsdbadm5dcstorage1.blob.core.windows.net/scripts/dc-install.ps1"]
    }
  SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File dc-install.ps1 ${var.adminpassword}"
    }
  PROTECTED_SETTINGS

  depends_on = [azurerm_virtual_machine.vm1]

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }

}