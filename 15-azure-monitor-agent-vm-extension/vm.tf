
module "vm-win" {
  source = "./modules/vm-win"

  prefix                    = local.prefix
  location                  = azurerm_resource_group.rg1.location
  rg_name                   = azurerm_resource_group.rg1.name
  tags                      = local.tags
  subnet_id                 = azurerm_subnet.sn1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
  vm_size                   = var.vm_size
  server_count              = var.server_count
  adminusername             = var.adminusername
  adminpassword             = var.adminpassword
}


resource "azurerm_virtual_machine_extension" "ama" {
  count                      = var.server_count
  name                       = join("-", [local.prefix, count.index + 1, "ama"])
  virtual_machine_id         = element(module.vm-win.vm_id, count.index)
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = "true"
  depends_on                 = [module.vm-win, azurerm_log_analytics_workspace.logging_ws]

  tags = merge(var.tags, tomap({ "firstapply" = timestamp() }))

  lifecycle {
    ignore_changes = [tags]
  }
}