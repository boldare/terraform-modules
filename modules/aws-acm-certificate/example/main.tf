terraform {
  required_providers {
    aws = "~>4.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "zone" {
  name    = "boldare.com"
  comment = "Hosted Zone"
}

module "api_cert" {
  source = "../"

  zone_id = aws_route53_zone.zone.zone_id
  domain  = "api.boldare.com"
}

module "api2_cert" {
  source = "../"

  zone_id = aws_route53_zone.zone.zone_id
  domain  = "api2.boldare.com"
}
