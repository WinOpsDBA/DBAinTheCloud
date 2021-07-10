# terraform plan -var-file=11-tf-security-tests.tfvars -var "build=20200703.1"

location               = "westeurope"
environment_name       = "d1"
project_name           = "dm11"
adminusername          = "devadmin"
network_size           = 12
network_no_dc          = 15
vm_size_dc             = "Standard_B1ms"
network_no_ado         = 16
vm_size_ado            = "Standard_B1ms"
network_no_sql         = 17
vm_size_sql            = "Standard_E2as_v4"
custom_script_name_dc  = "dc-install.ps1"
custom_script_name_ado = "ado-install.ps1"
custom_script_name_sql = "sql-install.ps1"