output "vm_id" {
  value = azurerm_virtual_machine.vm1.*.id
}
