terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source                = "aws"
      version               = "~>3.0, < 4.0"
      configuration_aliases = [aws, aws.global, aws.hosted_zone]
    }
  }
}
