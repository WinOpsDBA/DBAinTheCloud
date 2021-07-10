# 09-sql-server-tests

## Cloud lab with customised SQL Server VM, domain controller and Azure DevOps build agent in Azure with use of Terraform.

This folder contains code used for creating the cloud lab described in my [blog post](http://www.winopsdba.com/blog/Azure-cloud-lab-SQL-server-DevOps-agent-and-DC.html). How to create and customize Azure SQL Server VM with use of PowerShellDSC (SqlServerDsc, NetworkingDsc) and T-SQL. And how to add it to a cloud lab with a domain controller and Azure DevOps build agent in Azure with use of Terraform.
 
## Infrastructure
Infrastructure overview.
- 1 x storage
- 1 x vnet
- 3 x subnets
- 1 x Domain controller
- 1 x Azure DevOps agent
- 1 x SQL server
 
## terraform version
Terraform version used for build.
- Terraform v1.0.1
- provider registry.terraform.io/hashicorp/azurerm v2.64.0