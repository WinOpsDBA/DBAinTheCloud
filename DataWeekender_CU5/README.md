# Data Weekender CU5

'''
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
client_secret   = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
tenant_id       = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

adminpassword = "dw5P@55!"
'''

## terraform init

'''
terraform init -backend-config "subscription_id=<REMOVED>" -backend-config "client_id=<REMOVED>" -backend-config "client_secret=<REMOVED>" -backend-config "tenant_id=<REMOVED>"
'''

## terraform plan

### terraform plan for AzureSQL

'''
terraform plan -var-file=azure-sql.tfvars -var-file=/home/user/dev/secret/secret.tfvars -var "allowed_ip=$(curl -s https://ipconfig.io)"
'''

### terraform plan for Azure Windows VM with SQL Server Development

'''
terraform plan -var-file=sql-server.tfvars -var-file=/home/user/dev/secret/secret.tfvars -var "allowed_ip=$(curl -s https://ipconfig.io)"
'''

### terraform plan for Azure Linux VM with SQL Server Express

'''
terraform plan -var-file=sql-server-linux.tfvars -var-file=/home/user/dev/secret/secret.tfvars -var "allowed_ip=$(curl -s https://ipconfig.io)"
'''