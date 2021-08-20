/**
 * # AWS Generate multi zone cert
 * Module for creating SSL certificate for multiple domains in different route53 zones (eg. different TLD domains).
 * Limitation: Wildcard domains.
 */
# Partly based on https://gist.github.com/chancez/dfaaf799b98698839d65ebba55db7d44

locals {
  # Produces a list of maps of domains and their zone
  list_of_domains_with_zone = [
    for zone, domains in var.certificates : {
      for domain in domains :
      domain => zone
    }
  ]
  # Produces a map {domain = zone}
  domain_to_zone = merge({
    for domain, zone in merge(flatten([local.list_of_domains_with_zone])...) :
    domain => zone
  })

  # A list of domains. Sorted to ensure stability if the map order changes.
  domains = sort(keys(local.domain_to_zone))
}

resource "aws_acm_certificate" "cert" {
  domain_name               = local.domains[0]
  subject_alternative_names = slice(local.domains, 1, length(local.domains))

  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "cert_validation" {
  for_each = {
    for option in aws_acm_certificate.cert.domain_validation_options : option.domain_name => {
      name    = option.resource_record_name
      record  = option.resource_record_value
      type    = option.resource_record_type
      zone_id = local.domain_to_zone[option.domain_name]
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  depends_on = [
    aws_route53_record.cert_validation
  ]
}
