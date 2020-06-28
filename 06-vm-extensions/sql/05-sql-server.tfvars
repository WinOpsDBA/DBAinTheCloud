# terraform plan -var-file=05-sql-server.tfvars -var "build=20200515.1"

location           = "westeurope"
core_name          = "d1-dm5-sql" # environment and project name - development demo 3
storage_name       = "winopsdbadm5sqlstorage1"
custom_script_name = "sql-install.ps1"
server_count       = 1
adminusername      = "devadmin"
network_size       = 12
network_no         = 5
vm_size            = "Standard_DS2_v2"
vn_name            = "a-d1-dm5-dc-vn"
vn_rg_name         = "a-d1-dm5-dc-rg"
dns_servers        = "10.10.0.68"
