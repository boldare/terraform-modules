terraform {
  required_version = ">= 1.0"

  required_providers {
    aws        = ">= 4.0, < 5.0"
    kubernetes = ">= 2.0, < 3.0"
  }
}
