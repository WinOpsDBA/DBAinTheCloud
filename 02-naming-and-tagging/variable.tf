## variables

# prefix / project
variable "prefix" {
  default = "a-d1-fin"
}

variable "location" {
  default = "westeurope"
}

variable "build" {
  default = "manual"
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "tags" {
  type = "map"
  default = {
    Terraform        = "true",
    Environment      = "Development 1"
    SupportOwner     = "suport@__domain__.com",
    ProductOwner     = "finance@__domain__.com",
    DevelopmentOwner = "development@__domain__.com"
  }
}

locals {
  tags = "${merge(
    var.tags,
    map(
      "Build", "${var.build}",
      "Project", "${var.prefix}",
      "Location", "${var.location}"
    )
  )}"
}
