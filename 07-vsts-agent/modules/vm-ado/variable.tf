# variables

variable "prefix" {}

variable "location" {}

variable "rg_name" {}

variable "subnet_id" {}

variable "network_security_group_id" {}

variable "vm_size" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "servicepassword" {}

variable "ado_token" {}

variable "storage_name" {}

variable "server_count" {}

variable "dc_ip" {}

variable "tags" {
  type = map

  default = {
    Terraform = "true"
  }
}
