resource "azurerm_storage_account" "sa1" {
  name                     = var.storage_name
  location                 = azurerm_resource_group.rg1.location
  resource_group_name      = azurerm_resource_group.rg1.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_subnet.sn1, azurerm_subnet.sn2]

  network_rules {
    default_action             = "Deny"
    ip_rules                   = [var.allowed_ip]
    virtual_network_subnet_ids = ["${azurerm_subnet.sn1.id}", "${azurerm_subnet.sn2.id}", "${azurerm_subnet.sn3.id}"]
  }

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }

}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_name  = azurerm_storage_account.sa1.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "script1" {
  name                   = "dc-install.ps1"
  storage_account_name   = azurerm_storage_account.sa1.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "dc-install.ps1"
}

resource "azurerm_storage_blob" "script2" {
  name                   = "ado-install.ps1"
  storage_account_name   = azurerm_storage_account.sa1.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "ado-install.ps1"
}
