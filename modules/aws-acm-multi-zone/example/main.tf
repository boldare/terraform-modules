provider "aws" {
  region = "eu-west-1"
}

module "api_cert" {
  source = "../"

  certificates = {
    Z01234456789ABCDEFGH0 = [
      "foo.example.com",
      "bar.example.com"
    ],
    Z98765432100ZYXWVUTS9 = [
      "website.domain.com",
      "www.website.domain.com"
    ]
  }
}

output "domains" {
  value = module.api_cert.list_of_domains
}

output "certificate_arn" {
  value = module.api_cert.certificate_arn
}
