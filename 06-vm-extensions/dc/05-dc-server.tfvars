# terraform plan -var-file=05-dc-server.tfvars -var "build=20200609.1"

location           = "westeurope"
core_name          = "d1-dm5-dc" # environment and project name - development demo 3
storage_name       = "winopsdbadm5dcstorage1"
custom_script_name = "dc-install.ps1"
adminusername      = "devadmin"
network_size       = 12
network_no         = 4
ip_address         = "10.10.0.68"
vm_size            = "Standard_B2ms"
