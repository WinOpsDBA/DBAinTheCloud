output "vnet_rg_name" {
  value = "${azurerm_resource_group.rg1.name}"
}

output "vnet_name" {
  value = "${azurerm_virtual_network.vn1.name}"
}
