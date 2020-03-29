provider aws {
  region = "eu-central-1"
}

module "waf" {
  source = "../"

  name        = "my-rule"
  allowed_cidrs = ["127.0.0.1/32", "8.8.8.8/32"]
}

output "web_acl_id" {
  value       = module.waf.web_acl_id
  description = "Web Application Firewall service ID limiting access to CloudFront distribution to given IP adresses."
}
