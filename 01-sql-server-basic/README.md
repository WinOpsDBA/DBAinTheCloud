# Stand alone SQL server in Azure __sql-server-basic-1.0__ #

This example shows how to build a stand-alone SQL Server and cloud infrastructure in Microsoft Azure cloud with Terraform.

__SECURITY NOTE__

There are sensitive data (i.e. passwords) in .tf file, it is for demonstration purposes only and it will be addressed in the future version.

## Goal ##

The environment with one stand-alone SQL Server 2016 accessible through RDP from dedicated public IP address.

## Infrastructure overview ##

* Core infrastructure
    - resource group
    - network security group and rule to allow RDP access from public IP address
    - virtual network
    - subnet

* SQL server
    - public IP address
    - network interface
    - stand-alone SQL 2016 server based on the latest Microsoft image

## Note ##

After building the server you can check public IP address in Azure portal or by using following command to query public IP address details. 

'''
az network public-ip show -n demo1-pip1 -g demo1-rg
'''
