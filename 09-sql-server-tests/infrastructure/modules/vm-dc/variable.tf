# variables

variable "prefix" {}

variable "location" {}

variable "rg_name" {}

variable "subnet_id" {}

variable "network_security_group_id" {}

variable "vm_size" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "domain_name" {}

variable "servicepassword" {}

variable "storage_name" {}

variable "ip_address_dc" {}

variable "tags" {
  type = map

  default = {
    Terraform = "true"
  }
}
