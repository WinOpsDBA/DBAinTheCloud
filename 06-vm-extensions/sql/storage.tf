resource "azurerm_storage_account" "sa1" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules                   = [var.allowed_ip]
    virtual_network_subnet_ids = [azurerm_subnet.sn1.id]
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

resource "azurerm_storage_blob" "script_ps1" {
  name = "sql-install.ps1"
  storage_account_name   = azurerm_storage_account.sa1.name
  storage_container_name = azurerm_storage_container.scripts.name
  type                   = "Block"
  source                 = "sql-install.ps1"
}
