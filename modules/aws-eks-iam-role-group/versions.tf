terraform {
  required_version = ">= 1.0"

  required_providers {
    aws        = ">= 3.0, < 4.0"
    kubernetes = ">= 2.0, < 3.0"
  }
}
