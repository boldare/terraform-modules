terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "hashicorp/oci"
      version = ">= 4.0"
    }
  }
}
