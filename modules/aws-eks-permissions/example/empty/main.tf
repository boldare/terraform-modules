provider "aws" {
  version = "~>3.0"
  region  = "us-east-1"
}

module "permissions" {
  source = "../../"
}
