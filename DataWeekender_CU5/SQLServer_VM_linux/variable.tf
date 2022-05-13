## variables
variable "environment_name" {}

variable "project_name" {}

variable "location" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "allowed_ip" {}

variable "network_size" {}

variable "network_no_sql" {}

variable "vm_size_sql" {}

variable "server_count" {}

variable "sql_server_port" {}

variable "build" {
  default = "manual"
}

variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "tags" {
  type = map(any)

  default = {
    Terraform = "true"
  }
}

variable "region_code" {
  type = map(any)
  default = {
    "westeurope"  = "a"
    "northeurope" = "b"
  }
}

variable "vnets" {
  type = map(any)
  default = {
    "westeurope"  = "10.10.0.0/16"
    "northeurope" = "10.20.0.0/16"
  }
}

locals {
  tags = merge(
    var.tags,
    tomap({
      "Build"    = var.build,
      "Prefix"   = local.prefix,
      "Location" = var.location
    })
  )

  storage_name = "winopsdba${var.project_name}storage1"

  prefix = "${var.region_code[var.location]}-${var.environment_name}-${var.project_name}"

  sn1_address_prefix = cidrsubnet(var.vnets[var.location], var.network_size, var.network_no_sql)

}
