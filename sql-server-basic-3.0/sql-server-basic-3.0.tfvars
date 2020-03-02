# terraform plan -var-file=sql-server-basic-3.0.tfvars -var "build=0.0.0.1"

location      = "westeurope"
core_name     = "d1-dm3" # environment and project name - development demo 3
server_count  = 1
adminusername = "devadmin"
network_size  = 12
network_no    = 3
vm_size       = "Standard_DS2_v2"
