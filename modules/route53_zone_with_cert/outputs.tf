output "name" {
  value = aws_route53_zone.zone.name
}

output "id" {
  value = aws_route53_zone.zone.id
}

output "name_servers" {
  value = aws_route53_zone.zone.name_servers
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}
