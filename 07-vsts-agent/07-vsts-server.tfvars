# terraform plan -var-file=07-vsts-server.tfvars -var "build=20200910.1"

location           = "westeurope"
core_name          = "d1-dm7" # environment and project name - development demo 7
storage_name       = "winopsdbadm7storage1"
adminusername      = "devadmin"
network_size       = 12
network_no_dc      = 6
ip_address_dc      = "10.10.0.100"
vm_size_dc         = "Standard_B1ms"
network_no_ado      = 7
vm_size_ado       = "Standard_B1ms"
network_no_sql      = 8
custom_script_name_dc = "dc-install.ps1"
custom_script_name_ado = "ado-install.ps1"