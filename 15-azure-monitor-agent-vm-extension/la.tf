# log analytics workspace

resource "azurerm_log_analytics_workspace" "logging_ws" {
  name                = join("-", [local.prefix, "la1"])
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# data collection rule

resource "azurerm_monitor_data_collection_rule" "rule1" {
  name                = join("-", [local.prefix, "rule1"])
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  depends_on          = [azurerm_virtual_machine_extension.ama]

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.logging_ws.id
      name                  = "log-analytics"
    }
  }

  data_flow {
    streams      = ["Microsoft-Event"]
    destinations = ["log-analytics"]
  }

  data_sources {
    windows_event_log {
      streams = ["Microsoft-Event"]
      x_path_queries = ["Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]",
        "Security!*[System[(band(Keywords,13510798882111488))]]",
      "System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]"]
      name = "eventLogsDataSource"
    }
  }
}

# data collection rule association

resource "azurerm_monitor_data_collection_rule_association" "dcra1" {
  count                   = var.server_count
  name                    = join("-", [local.prefix, count.index + 1, "dcra"])
  target_resource_id      = element(module.vm-win.vm_id, count.index)
  data_collection_rule_id = azurerm_monitor_data_collection_rule.rule1.id
}
