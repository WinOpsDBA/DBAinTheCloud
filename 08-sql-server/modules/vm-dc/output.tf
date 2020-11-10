output "dc_ip" {
  value = "${azurerm_network_interface.nic1.private_ip_address}"
}
