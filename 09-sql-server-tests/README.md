# 09-sql-server-tests

## Cloud lab with customised SQL Server VM, domain controller and Azure DevOps build agent in Azure with use of Terraform.

This folder contains code used for creating and testing the cloud lab described in my [blog post](http://www.winopsdba.com/blog/azure-cloud-lab-sql-server-pester-cicd-pipeline.html). How to create a cloud lab with customised SQL Server VM, domain controller and Azure DevOps build agent in Azure with use of [Terraform](https://github.com/hashicorp/terraform) as part of CI/CD pipeline and test it with [Pester 5](https://github.com/pester/Pester).

 
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
- Terraform v0.14.3
- provider registry.terraform.io/hashicorp/azurerm v2.42.0