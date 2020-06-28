## resource group ##
resource "azurerm_resource_group" "rg1" {
  name     = "${local.prefix}-rg"
  location = var.location

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}
