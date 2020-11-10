# variables

variable "prefix" {}

variable "location" {}

variable "rg_name" {}

# variable "vn_address_space" {}

# variable "sn1_address_prefix" {}

# variable "sn2_address_prefix" {}


variable "subnet_id" {}

variable "network_security_group_id" {}

variable "vm_size" {}

variable "adminusername" {}

variable "adminpassword" {}

variable "servicepassword" {}

variable "storage_name" {}

variable "dc_ip" {}

variable "server_count" {}

# variable "dns_servers" {}

variable "tags" {
  type = map

  default = {
    Terraform = "true"
  }
}


# ## variables
# variable "core_name" {}

# variable "storage_name" {}

# variable "custom_script_name" {}

# variable "location" {}


# variable "ip_address" {}

# variable "allowed_ip" {}

# variable "network_size" {}

# variable "network_no" {}

# variable "vm_size" {}

# variable "build" {}

# variable "subscription_id" {}
# variable "tenant_id" {}
# variable "client_id" {}
# variable "client_secret" {}

# variable "tags" {
#   type = map

#   default = {
#     Terraform = "true"
#   }
# }

# variable "region_code" {
#   type = map
#   default = {
#     "westeurope"  = "a"
#     "northeurope" = "b"
#   }
# }

# variable "vnets" {
#   type = map
#   default = {
#     "westeurope"  = "10.10.0.0/16"
#     "northeurope" = "10.20.0.0/16"
#   }
# }

# locals {
#   tags = "${merge(
#     var.tags,
#     map(
#       "Build", "${var.build}",
#       "Prefix", "${local.prefix}",
#       "Location", "${var.location}"
#     )
#   )}"
#   prefix = "${var.region_code["${var.location}"]}-${var.core_name}"
# }
