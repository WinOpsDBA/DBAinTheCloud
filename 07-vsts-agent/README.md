# 07-vsts-agent

## How to configure cloud lab with Azure DevOps agent and DC in Terraform.

This folder contains code used for creating the cloud lab described in my [blog post](http://www.winopsdba.com/blog/Azure-cloud-lab-DevOps-agent-and-DC.html). How to create a test environment/cloud lab with a domain controller and Azure DevOps (VSTS) agent in Terraform.
 
## Infrastructure
Infrastructure overview.
- 1 x storage
- 1 x vnet
- 3 x subnets
- 1 x Domain controller
- 1 x Azure DevOps agent
 
## terraform version
Terraform version used for build.
- Terraform v0.13.4
- provider registry.terraform.io/hashicorp/azurerm v2.18.0