resource "azurerm_subnet" "sn1" {
  name                 = "${local.prefix}-sn"
  resource_group_name  = "${var.vn_rg_name}"
  virtual_network_name = "${var.vn_name}"
  address_prefix       = "${cidrsubnet("${var.vnets["${var.location}"]}", "${var.network_size}", "${var.network_no}")}"
  service_endpoints    = ["Microsoft.Storage"]
}
