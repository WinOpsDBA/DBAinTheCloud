## resource group ##
resource "azurerm_resource_group" "rg1" {
  name     = "${local.prefix}-rg"
  location = var.location

  tags = merge(local.tags, map("FirstApply", timestamp(), "LastApply", timestamp()))

  lifecycle {
    ignore_changes = [tags.FirstApply]
  }
}

module "vm-dc" {
  source = "./modules/vm-dc"

  prefix                    = local.prefix
  location                  = azurerm_resource_group.rg1.location
  rg_name                   = azurerm_resource_group.rg1.name
  tags                      = local.tags
  subnet_id                 = azurerm_subnet.sn1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
  vm_size                   = var.vm_size_dc
  adminusername             = var.adminusername
  adminpassword             = var.adminpassword
  servicepassword           = var.servicepassword
  domain_name               = local.domain_name
  storage_name              = azurerm_storage_account.sa1.name
  ip_address_dc             = cidrhost(azurerm_subnet.sn1.address_prefixes.0, 4)
}

module "vm-ado" {
 source                    = "./modules/vm-ado"
 server_count              = 1
 prefix                    = local.prefix
 location                  = azurerm_resource_group.rg1.location
 rg_name                   = azurerm_resource_group.rg1.name
 tags                      = local.tags
 subnet_id                 = azurerm_subnet.sn2.id
 network_security_group_id = azurerm_network_security_group.nsg1.id
 vm_size                   = var.vm_size_ado
 adminusername             = var.adminusername
 adminpassword             = var.adminpassword
 servicepassword           = var.servicepassword
 ado_token                 = var.ado_token
 domain_name               = local.domain_name
 storage_name              = azurerm_storage_account.sa1.name
 dc_ip                     = module.vm-dc.dc_ip
 depends_on                = [module.vm-dc]
}

module "vm-sql" {
 source                    = "./modules/vm-sql"
 server_count              = 1
 prefix                    = local.prefix
 location                  = azurerm_resource_group.rg1.location
 rg_name                   = azurerm_resource_group.rg1.name
 tags                      = local.tags
 subnet_id                 = azurerm_subnet.sn3.id
 network_security_group_id = azurerm_network_security_group.nsg1.id
 vm_size                   = var.vm_size_sql
 adminusername             = var.adminusername
 adminpassword             = var.adminpassword
 servicepassword           = var.servicepassword
 domain_name               = local.domain_name
 storage_name              = azurerm_storage_account.sa1.name
 dc_ip                     = module.vm-dc.dc_ip
 depends_on                = [module.vm-dc]
}
