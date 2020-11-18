## variables
variable "core_name" {}

variable "location" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "allowed_ip" {}

variable "server_count" {}

variable "network_size" {}

variable "network_no" {}

variable "vm_size" {}

variable "build" {}

variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "tags" {
  type = map

  default = {
    Terraform = "true"
  }
}

variable "region_code" {
  type = map
  default = {
    "westeurope"  = "a"
    "northeurope" = "b"
  }
}

variable "vnets" {
  type = map
  default = {
    "westeurope"  = "10.10.0.0/16"
    "northeurope" = "10.20.0.0/16"
  }
}

locals {
  tags = "${merge(
    var.tags,
    map(
      "Build", "${var.build}",
      "Prefix", "${local.prefix}",
      "Location", "${var.location}"
    )
  )}"
  prefix = "${var.region_code["${var.location}"]}-${var.core_name}"
}
