output "public_ip_address" {
  value = [azurerm_public_ip.pip1.*.ip_address]
}