# network public ip

resource "azurerm_public_ip" "pip1" {
  count                   = var.server_count
  name                    = "${var.prefix}-win${count.index + 1}-pip1"
  location                = var.location
  resource_group_name     = var.rg_name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = merge(var.tags, tomap({ "firstapply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags]
  }
}

# network interface

resource "azurerm_network_interface" "nic1" {
  count               = var.server_count
  name                = "${var.prefix}-win${count.index + 1}-nic1"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${var.prefix}-win${count.index + 1}-ip1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip1.*.id, count.index)
  }

  tags = merge(var.tags, tomap({ "firstapply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags]
  }
}

# create virtual machine

resource "azurerm_virtual_machine" "vm1" {
  count                         = var.server_count
  name                          = "${var.prefix}-win${count.index + 1}"
  location                      = var.location
  resource_group_name           = var.rg_name
  network_interface_ids         = [element(azurerm_network_interface.nic1.*.id, count.index)]
  vm_size                       = var.vm_size
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-smalldisk-g2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-win${count.index + 1}-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-win${count.index + 1}"
    admin_username = var.adminusername
    admin_password = var.adminpassword
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  identity {
    type         = "SystemAssigned"
  }

  tags = merge(var.tags, tomap({ "firstapply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags]
  }

}
