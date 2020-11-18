# Naming and tagging #

This example shows how to implement tags on Azure resource with Terraform.

## Goal ##

Implement three types of tags to the resource group

* static tags

```
"Environment"      = "Development 1"
"Location"         = "westeurope"
"Project"          = "a-d1-fin"
"DevelopmentOwner" = "development@__domain__.com"
"ProductOwner"     = "finance@__domain__.com"
"SupportOwner"     = "suport@__domain__.com"
```

* variable tags

```
"Build"            = "manual" 
```

* dynamic tags (firstapply tag is recorded only when we run apply first time)

```
"FirstApply"       = "2019-10-15T12:08:20Z"
"LastApply"        = "2019-10-15T12:08:20Z"
```

## Infrastructure overview ##

* Core infrastructure
    - resource group
