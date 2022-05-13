resource "azurerm_mssql_server" "mssqlserver" {
  name                         = "${local.prefix}-asql1"
  resource_group_name          = azurerm_resource_group.rg1.name
  location                     = azurerm_resource_group.rg1.location
  version                      = "12.0"
  administrator_login          = var.adminusername
  administrator_login_password = var.adminpassword
  minimum_tls_version          = "1.2"

  tags = merge(local.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }
}

resource "azurerm_mssql_firewall_rule" "fwr1" {
  name             = "${local.prefix}-fwr1"
  server_id        = azurerm_mssql_server.mssqlserver.id
  start_ip_address = var.allowed_ip
  end_ip_address   = var.allowed_ip
}

resource "azurerm_mssql_database" "db1" {
  name                        = "blank-sample-sqldb"
  server_id                   = azurerm_mssql_server.mssqlserver.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  auto_pause_delay_in_minutes = 60

  tags = merge(local.tags, tomap({ FirstApply = timestamp(), LastApply = timestamp() }))

  lifecycle {
    ignore_changes = [tags["FirstApply"]]
  }
}
