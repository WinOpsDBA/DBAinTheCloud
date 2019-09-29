## variables

variable "prefix" {
  default = "workbench"
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

variable "allowed-ips" {
}


variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}


## resource group
resource "azurerm_resource_group" "rg1" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

## network network security group
resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-nsg"
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
}

## network network security group rupe allowinf inbound traffic
resource "azurerm_network_security_rule" "i1000" {
  name                   = "rdp-from-home"
  priority               = 1000
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "3389"
  #source_address_prefix       = "${var.home-ip}"
  source_address_prefixes     = "${var.allowed-ips}"
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
  name                 = "${var.prefix}-sn"
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  virtual_network_name = "${azurerm_virtual_network.vn1.name}"
  address_prefix       = "10.10.10.0/24"
  service_endpoints    = ["Microsoft.Storage"]
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
  name                      = "${var.prefix}-pc1-nic1"
  location                  = "${azurerm_resource_group.rg1.location}"
  resource_group_name       = "${azurerm_resource_group.rg1.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg1.id}"

  ip_configuration {
    name                          = "${var.prefix}-pc1-ip1"
    subnet_id                     = "${azurerm_subnet.sn1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pip1.id}"
  }
}

## Create storage

resource "azurerm_storage_account" "sa1" {
  name                = "winopsdbaworkbenchstor1"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    #ip_rules                   = ["${var.home-ip}"]
    ip_rules                   =  "${var.allowed-ips}"
    virtual_network_subnet_ids = ["${azurerm_subnet.sn1.id}"]
  }
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_name  = "${azurerm_storage_account.sa1.name}"
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "script_ps1" {
  name                   = "install.ps1"
  resource_group_name    = "${azurerm_resource_group.rg1.name}"
  storage_account_name   = "${azurerm_storage_account.sa1.name}"
  storage_container_name = "${azurerm_storage_container.scripts.name}"
  type                   = "block"
  source                 = "install.ps1"
}
## create virtual machine

resource "azurerm_virtual_machine" "vm1" {
  name                          = "${var.prefix}-app1"
  location                      = "${azurerm_resource_group.rg1.location}"
  resource_group_name           = "${azurerm_resource_group.rg1.name}"
  network_interface_ids         = ["${azurerm_network_interface.nic1.id}"]
  vm_size                       = "Standard_B2ms"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-app1-disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.prefix}-app1"
    admin_username = "${var.adminusername}"
    admin_password = "${var.adminpassword}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}

resource "azurerm_virtual_machine_extension" "ps1" {
  name                 = "hostname"
  location             = "${azurerm_resource_group.rg1.location}"
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  virtual_machine_name = "${azurerm_virtual_machine.vm1.name}"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "fileUris":["https://winopsdbaworkbenchstor1.blob.core.windows.net/scripts/install.ps1"],
        "commandToExecute":"powershell -ExecutionPolicy Unrestricted -File install.ps1"
    }
  SETTINGS

}