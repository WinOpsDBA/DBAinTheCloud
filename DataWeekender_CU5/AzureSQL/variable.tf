## variables
variable "environment_name" {}

variable "project_name" {}

variable "location" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "servicepassword" {}

variable "allowed_ip" {}

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


locals {
  tags = merge(
    var.tags,
    tomap({
      Build    = var.build,
      Prefix   = local.prefix,
      Location = var.location
    })
  )

  storage_name = "winopsdba${var.environment_name}${var.project_name}st1"
  domain_name  = "winopsdba-${var.project_name}"

  prefix = "${var.region_code[var.location]}-${var.environment_name}-${var.project_name}"
}
