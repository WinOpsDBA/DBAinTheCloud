## variables

variable "prefix" {
  default = "demo1"
}

variable "location" {
  default = "West Europe"
}

variable "adminusername" {
  default = "devadmin"
}

# !!! SECURITY RISK !!!
# Password in plane text being replicated to git repository (ouch!)

variable "adminpassword" {
  default = "P@55w0rd2019!"
}

# !!! SECURITY RISK !!!
# Public IP address in plane text, replicated to git repository (ouch!)

variable "home-ip" {
  default = "192.168.0.1"
}

## resource group
resource "azurerm_resource_group" "rg1" {
  name                     = "${var.prefix}-rg"
  location                 = "${var.location}"
}

## network network security group
resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-nsg"
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
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
  source_address_prefix       = "${var.home-ip}"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg1.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg1.name}"
}

## network virtual network

resource "azurerm_virtual_network" "vn1" {
  name                = "${var.prefix}-vn"
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  address_space       = ["10.10.0.0/16"]
}

## network subnet

resource "azurerm_subnet" "sn1" {
  name                      = "${var.prefix}-sn"
  resource_group_name       = "${azurerm_resource_group.rg1.name}"
  virtual_network_name      = "${azurerm_virtual_network.vn1.name}"
  address_prefix            = "10.10.10.0/24"
}

## network public ip

resource "azurerm_public_ip" "pip1" {
  name                    = "${var.prefix}-pip1"
  location                = "${azurerm_resource_group.rg1.location}"
  resource_group_name     = "${azurerm_resource_group.rg1.name}"
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

## network interface

resource "azurerm_network_interface" "nic1" {
  name                      = "${var.prefix}-sql1-nic1"
  location                  = "${azurerm_resource_group.rg1.location}"
  resource_group_name       = "${azurerm_resource_group.rg1.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg1.id}"

  ip_configuration {
    name                          = "${var.prefix}-sql1-ip1"
    subnet_id                     = "${azurerm_subnet.sn1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip1.id}"
  }
}

# create virtual machine
resource "azurerm_virtual_machine" "vm1" {
  name                          = "${var.prefix}-sql1"
  location                      = "${azurerm_resource_group.rg1.location}"
  resource_group_name           = "${azurerm_resource_group.rg1.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic1.id}"]
  vm_size                       = "Standard_B4ms"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2016SP2-WS2016"
    sku       = "SQLDEV"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-sql1-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-sql1"
    admin_username = "${var.adminusername}"
    admin_password = "${var.adminpassword}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}