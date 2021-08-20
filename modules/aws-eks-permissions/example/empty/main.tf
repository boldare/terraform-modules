terraform {
  required_providers {
    aws = "~>3.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "permissions" {
  source = "../../"
}
