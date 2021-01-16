## variables
variable "environment_name" {}

variable "project_name" {}

variable "custom_script_name_dc" {}

variable "custom_script_name_ado" {}

variable "custom_script_name_sql" {}

variable "location" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "servicepassword" {}

variable "ado_token" {}

variable "allowed_ip" {}

variable "network_size" {}

variable "network_no_dc" {}

variable "network_no_ado" {}

variable "network_no_sql" {}

variable "vm_size_dc" {}
variable "vm_size_ado" {}
variable "vm_size_sql" {}

variable "build" {}

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
    map(
      "Build", var.build,
      "Prefix", local.prefix,
      "Location", var.location
    )
  )

  storage_name = "winopsdba${var.project_name}storage1"
  domain_name  = "winopsdba-${var.project_name}"

  prefix = "${var.region_code[var.location]}-${var.environment_name}-${var.project_name}"

  sn1_address_prefix = cidrsubnet(var.vnets[var.location], var.network_size, var.network_no_dc)
  sn2_address_prefix = cidrsubnet(var.vnets[var.location], var.network_size, var.network_no_ado)
  sn3_address_prefix = cidrsubnet(var.vnets[var.location], var.network_size, var.network_no_sql)

}
