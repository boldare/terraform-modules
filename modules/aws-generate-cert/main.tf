/**
 * # AWS generate cert
 * Simple module creating SSL certificate for domain including all nessesary Route53 records .
 */

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
  aws_route53_record.cert_validation.fqdn]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options[0].resource_record_type
  zone_id = var.zone_id
  records = [
  aws_acm_certificate.cert.domain_validation_options[0].resource_record_value]
  ttl = 60
}
