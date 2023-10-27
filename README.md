# DBAinTheCloud

This repository contains code for scripts and configuration I am demonstrating in my blog [DBAinTheCloud](https://www.winopsdba.com).

You will find samples of code in:
- [x] Terraform
- [x] Powershell
- [x] PowershellDSC
- [x] T-SQL
- [ ] Python

## 01-sql-server-basic

How to build stand-alone SQL server in Azure - infrastructure as a code with the use of Terraform.

## 02-naming-and-tagging

Naming convention you can implement in Azure with use of Terraform scripts.

## 03-sql-server-basic

How to build multiple SQL servers in Azure with a single Terraform command.

## 04-sql-server-basic

How to build and destroy SQL server in Azure DevOps pipeline with use of Terraform scripts.

## 05-sql-server-pester-tests

Step by step guide how to add environment Pester tests into Azure DevOps CI/CD pipeline.

## 06-vm-extensions

How to configure Azure VM extension with the use of Terraform. Step by step guide how to add VM to a domain, configure the AV agent and run a custom script.

## 07-vsts-agent

How to create a test environment/cloud lab with a domain controller and Azure DevOps (VSTS) agent in Terraform.

## 08-sql-server

How to create and customize Azure SQL Server VM with use of PowerShellDSC and T-SQL. And how to add it to a cloud lab with domain controller and Azure DevOps build agent in Azure with use of Terraform.

## 09-sql-server-tests

How to create a cloud lab with customised SQL Server VM, domain controller and Azure DevOps build agent in Azure with use of Terraform as part of CI/CD pipeline and test it with Pester 5.

## 10-secret-variable

How to expose secret variables in Azure DevOps CI/CD pipeline with use of powershell step.

## 11-tf-security-tests

DevSecOps - How to validate terraform script and run security static code analysis with use of tfsec as a part of Azure DevOps CI/CD pipeline.

## 12-container-trivy-sacnning

DevSecOps - How to scan a container for vulnerabilities and publish results as a part of Azure DevOps CI/CD pipeline.

## 14-dastardly-burp-cicd-dast-scanning

How to implement DAST security scanning for web application/portal with the use of the Dastardly tool as a part of Azure DevOps CI/CD pipeline.

## 15-azure-monitor-agent-vm-extension

How to nstalling Azure Monitor Agent virtual machine extension, configuring data collection rule and Log Analytics workspace with Terraform to collect Windows events.

## 16-finops-pipeline-cost-control

How to implemwnt a cost visibility and automated cost policy validation in development pipelines for IaC (Infrastructure as a Code) resources with use of infracost tool.

## 17-finops-budget-and-alerts

How to configure budget and alerts for Azure resource group in terraform code to provide cost visibility (FinOps).