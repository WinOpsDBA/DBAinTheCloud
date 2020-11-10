# terraform plan -var-file=08-sql-server.tfvars -var "build=20201104.1"

location               = "westeurope"
core_name              = "d1-dm8" # environment and project name - development demo 8
storage_name           = "winopsdbadm8storage1"
adminusername          = "devadmin"
network_size           = 12
network_no_dc          = 9
vm_size_dc             = "Standard_B1ms"
network_no_ado         = 10
vm_size_ado            = "Standard_B1ms"
network_no_sql         = 11
vm_size_sql            = "Standard_E2as_v4"
custom_script_name_dc  = "dc-install.ps1"
custom_script_name_ado = "ado-install.ps1"
custom_script_name_sql = "sql-install.ps1"