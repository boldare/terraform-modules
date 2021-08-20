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

  name_prefix = "BoldareCluster"

  autoscaling_create    = true
  dns_create            = true
  load_balancing_create = true
}

output "policies" {
  value = {
    dns            = module.permissions.dns_policy_arn
    autoscaling    = module.permissions.autoscaling_policy_arn
    load_balancing = module.permissions.load_balancing_policy_arn
  }
  description = "Map of all EKS permission ARNs."
}
