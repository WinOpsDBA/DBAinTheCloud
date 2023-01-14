variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "location" {}
variable "environment_name" {}
variable "project_name" {}
variable "vnet_address_space" {}
variable "network_size" {}
variable "network_no" {}
variable "vm_size" {}
variable "adminusername" {}
variable "adminpassword" {}
variable "server_count" {}
variable "allowed_ip" {}

variable "tags" {
  type = map(any)

  default = {
    terraform = "true"
  }
}

locals {
  tags = merge(
    var.tags,
    tomap({
      "prefix" : local.prefix,
      "location" : var.location
    })
  )

  prefix = join("-", ["a", var.environment_name, var.project_name])

  sn1_address_prefix = cidrsubnet(var.vnet_address_space, var.network_size, var.network_no)

}