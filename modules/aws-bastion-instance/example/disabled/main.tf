provider "aws" {
  region = "us-east-1"
}

module "bastion" {
  source = "../.."

  name = "bastion-instance"

  # Machine Launch Parameters
  instance_type           = "t3.nano"
  subnet_id               = var.subnet_id
  vpc_id                  = var.vpc_id
  disable_api_termination = true

  # Access
  ssh_key_name        = "example-key"
  allowed_cidr_blocks = [
    "18.202.145.21/32", # Boldare VPN IP
  ]
}
