provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  tenant_id       = "${var.tenant_id}"
  client_id       = "${var.client_id}"     # Application ID
  client_secret   = "${var.client_secret}" # Application secret
}
