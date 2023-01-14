variable "prefix" {}
variable "location" {}
variable "rg_name" {}
variable "subnet_id" {}
variable "network_security_group_id" {}
variable "vm_size" {}
variable "server_count" {}
variable "adminusername" {}
variable "adminpassword" {}

variable "tags" {
  type = map(any)

  default = {
    terraform = "true"
  }
}
