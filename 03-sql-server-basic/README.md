# Stand alone SQL server in Azure __sql-server-basic-2.0__ #

This example shows how to build a stand-alone SQL Server and cloud infrastructure in a greenfield scenario.

# Updates #

Infrastructure in this version is the same however there are few changes to Terraform scripts:

* split to multiple files (*.tf) 
* add variable file .tfvars
* add more variables/parameters and dynamic assignment it
    - build
    - count
    - virtual network map
    - tags
* improved security - no plain text password being replicated to the git repository

__SECURITY NOTE__ 

Please note that .tfvars might containing a sensitive data (i.e. passwords, subscryption details) and is excluded from git (.gitignore), for demonstration purpuoses the .tfvars.sample is included.

## goal ##

The environment with one stand-alone SQL Server 2016 accessible through RDP from home IP address. 

## Infrastructure overview ##

* Core infrastructure
    - resource group
    - network security group and rule to allow RDP access from piblic IP address
    - virtual network
    - subnet
* SQL server
    - public IP address
    - network interface 
    - stand-alone SQL 2016 server based on the latest Microsoft image

## Note ##

After building the server you can check public IP address in Azure portal or by using following command to query public IP address details. 

```     
az network public-ip show -n d1-dm2-pip1 -g d1-dm2-rg
```
