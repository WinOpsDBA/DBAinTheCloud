resource "azurerm_storage_account" "sa1" {
  name                     = local.storage_name
  location                 = azurerm_resource_group.rg1.location
  resource_group_name      = azurerm_resource_group.rg1.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny"
    ip_rules       = [var.allowed_ip]
  }

  tags = merge(local.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }

}

resource "azurerm_storage_container" "folder1" {
  name                  = "sql-backup"
  storage_account_name  = azurerm_storage_account.sa1.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "AdventureWorksLT2019.bak"
  storage_account_name   = azurerm_storage_account.sa1.name
  storage_container_name = azurerm_storage_container.folder1.name
  type                   = "Block"
  source                 = "../sample_sql_backup/AdventureWorksLT2019.bak"
}